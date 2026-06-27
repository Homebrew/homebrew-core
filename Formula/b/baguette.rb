class Baguette < Formula
  desc "Headless iOS Simulator manager and host-side input injection for iOS 26"
  homepage "https://tddworks.github.io/baguette/"
  url "https://github.com/tddworks/baguette/archive/refs/tags/v0.1.77.tar.gz"
  sha256 "fd3580b736c1c4ec1eab85c9053d209cceab7c8da3a82b09f2571129d15cc9cd"
  license "Apache-2.0"
  head "https://github.com/tddworks/baguette.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe: "817baef9b5bcbf20635027b6e5e843dba978f6ab5b040a083548c0d7a1f3b2f0"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    # replace version like upstreams release process
    inreplace "Sources/Baguette/App/Version.swift",
              "let baguetteVersion = \"0.1.61\"",
              %Q(let baguetteVersion = "#{version}")

    # Build the iOS-Simulator virtual-camera dylib from source rather than
    # using the prebuilt copy in the tarball. Mirrors upstream's
    # VirtualCamera/build.sh, compiled against the iphonesimulator SDK for this
    # formula's arch (arm64) straight into the SPM resource directory.
    # `-target *-simulator` stamps the iOS-Simulator platform load command and
    # `-Wl,-adhoc_codesign` ad-hoc signs the dylib at link time. Homebrew
    # re-signs it during relocation, which is fine: at runtime baguette copies
    # the dylib to a fresh content-hashed path before injecting it, so the
    # simulator's dyld loads the ad-hoc signature without the page-hash-cache
    # "invalid-page" rejection that only hits a replaced dylib at the same path.
    arch = Hardware::CPU.arch.to_s
    sdk = Utils.safe_popen_read("xcrun", "--sdk", "iphonesimulator", "--show-sdk-path").chomp
    vc = "Sources/Baguette/Resources/VirtualCamera"
    rm "#{vc}/VirtualCamera.dylib"
    system "xcrun", "clang", "-arch", arch, "-isysroot", sdk,
           "-target", "#{arch}-apple-ios17.0-simulator", "-dynamiclib",
           "-framework", "Foundation", "-framework", "UIKit",
           "-framework", "QuartzCore", "-framework", "CoreGraphics",
           "-framework", "AVFoundation", "-framework", "ImageIO",
           "-framework", "CoreServices", "-fobjc-arc", "-ldl",
           "-install_name", "@rpath/VirtualCamera.dylib", "-Wl,-adhoc_codesign",
           "-I", "VirtualCamera/Sources", "-o", "#{vc}/VirtualCamera.dylib",
           "VirtualCamera/Sources/SimCamInject.m",
           "VirtualCamera/Sources/SimCamPreviewLayerDriver.m",
           "VirtualCamera/Sources/SimCamFakePhoto.m",
           "VirtualCamera/Sources/SimCamSharedFrameReader.m"

    system "swift", "build", "--disable-sandbox", "-c", "release"

    # Binary and its SPM resource bundle must sit side-by-side at runtime —
    # WebRoot resolves the bundle via dladdr from the executable's directory.
    # Install both into libexec and symlink the binary into bin.
    libexec.install ".build/release/Baguette" => "baguette"
    libexec.install ".build/release/Baguette_Baguette.bundle"
    bin.install_symlink libexec/"baguette"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baguette --version")

    # The top-level help lists the simulator-control subcommands, confirming
    # the binary and its argument parser initialize without a booted device.
    assert_match "Headless iOS simulator control", shell_output("#{bin}/baguette --help")

    # Unknown subcommands are rejected with a usage error (exit code 64),
    # exercising real argument parsing offline with no booted simulator.
    assert_match "Usage: baguette", shell_output("#{bin}/baguette no-such-command 2>&1", 64)
  end
end
