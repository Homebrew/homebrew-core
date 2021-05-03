class Fvm < Formula
    desc "Simple cli to manage Flutter SDK versions per project"
    homepage "https://fvm.app"
    url "https://github.com/leoafarias/fvm/archive/2.0.1.tar.gz"
    sha256 "2a9107963214658eeb7b12af68e8db5274138d978913b38effa682f68041d63e"
    license "MIT"
  
    depends_on "dart-lang/dart/dart" => :build
  
    def install
      dart = Formula["dart-lang/dart/dart"].opt_bin
      
      pubspec = YAML.safe_load(File.read("pubspec.yaml"))
      version = pubspec["version"]
  
      # Tell the pub server where these installations are coming from.
      ENV["PUB_ENVIRONMENT"] = "homebrew:fvm"
  
      system dart/"pub", "get"
      
      if Hardware::CPU.is_64_bit?
        # Build a native-code executable on 64-bit systems only. 32-bit Dart
        # doesn't support this.
        system dart/"dart2native", "-Dversion=#{version}", "bin/main.dart",
               "-o", "fvm"
        bin.install "fvm"
      else
        system dart/"dart",
               "-Dversion=#{version}",
               "--snapshot=main.dart.app.snapshot",
               "--snapshot-kind=app-jit",
               "bin/main.dart", "version"
        lib.install "main.dart.app.snapshot"
  
        # Copy the version of the Dart VM we used into our lib directory so that if
        # the user upgrades their Dart VM version it doesn't break Sass's snapshot,
        # which was compiled with an older version.
        cp dart/"dart", lib
  
        (bin/"fvm").write <<~SH
          #!/bin/sh
          exec "#{lib}/dart" "#{lib}/main.dart.app.snapshot" "$@"
        SH
      end
      chmod 0555, "#{bin}/fvm"
    end
  
    test do
      # `test do` will create, run in and delete a temporary directory.
      #
      # This test will fail and we won't accept that! For Homebrew/homebrew-core
      # this will need to be a test that verifies the functionality of the
      # software. Run the test with `brew test fvm`. Options passed
      # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
      #
      # The installed folder is not in the path, so use the entire path to any
      # executables being tested: `system "#{bin}/program", "do", "something"`.
      system "false"
    end
  end
  
