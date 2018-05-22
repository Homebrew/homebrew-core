class Arangodb < Formula
  desc "The Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  stable do
    url "https://download.arangodb.com/Source/ArangoDB-3.3.9.tar.gz"
    sha256 "5b27a88c6e2c05e4ac96fb4cac6754a603a1ca2aef96359f374dd529d427569f"

    # Remove for > 3.3.9
    # Upstream commit from 22 May 2018 "Compile fix for homebrew (#5417)"
    if DevelopmentTools.clang_build_version <= 800
      patch do
        url "https://github.com/arangodb/arangodb/commit/6ca523f2700.patch?full_index=1"
        sha256 "bf3d4335578e31d356c85901b470398ddb231d71b9dbe7f8a28d818d9610ad66"
      end
    end
  end

  bottle do
    sha256 "279554d96c5a4f3e4016ee1b6e2642c1a73bb88cbe2ebcd26c972e087d32e2bb" => :high_sierra
    sha256 "dc584c8db6c143153ad0b99b05c78e7722e1c958e865364aa348485a703fbce8" => :sierra
    sha256 "664d3e90a8c1e29de94e35b5ec5e5b5a6f6908133e6aca32e4364cf35c0d024b" => :el_capitan
  end

  depends_on :macos => :yosemite
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  def install
    ENV.cxx11

    mkdir "build" do
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF
        -DASM_OPTIMIZATIONS=OFF
        -DCMAKE_INSTALL_DATADIR=#{share}
        -DCMAKE_INSTALL_DATAROOTDIR=#{share}
        -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
        -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      ]

      if ENV.compiler == "gcc-6"
        ENV.append "V8_CXXFLAGS", "-O3 -g -fno-delete-null-pointer-checks"
      end

      system "cmake", "..", *args
      system "make", "install"

      %w[arangod arango-dfdb arangosh foxx-manager].each do |f|
        inreplace etc/"arangodb3/#{f}.conf", pkgshare, opt_pkgshare
      end
    end
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    s = <<~EOS
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS

    s
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/arangod</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp
  end
end
