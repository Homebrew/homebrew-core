class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/0.8.0.tar.gz"
  sha256 "c807030d86490ebb633f8326319dac4036d41297598709670284e4f7044d7883"
  license "MIT"
  head "https://github.com/JohnSundell/Publish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43e882a02f169464d3b72b91c4221e605658f7f6a8989e069caecfd1d2c4caf6"
    sha256 cellar: :any_skip_relocation, big_sur:       "76ec25c3a77331097114f184bd69185e0b000d1b84f9f7be932021bcc62894cc"
  end

  if MacOS.version >= :big_sur
    # https://github.com/JohnSundell/Publish#system-requirements
    depends_on xcode: ["12.5", :build]
  else
    depends_on "swift" => :build
  end

  uses_from_macos "swift"

  def install
    swift_f = Formula["swift"]

    swift = if OS.mac? && MacOS.version <= :catalina
      swift_f.opt_prefix/"Swift-#{swift_f.version}.xctoolchain/usr/bin/swift"
    else
      "swift"
    end

    # Skip the shims for testing; do not merge
    if OS.linux?
      ENV["CC"] = swift_f.opt_libexec/"bin/clang"
      ENV["CXX"] = swift_f.opt_libexec/"bin/clang++"
    end

    system swift, "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/publish-cli" => "publish"
  end

  test do
    mkdir testpath/"test" do
      system "#{bin}/publish", "new"
      assert_predicate testpath/"test"/"Package.swift", :exist?
    end
  end
end
