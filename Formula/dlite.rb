class Dlite < Formula
  desc "Provides a way to use docker on OS X without docker-machine"
  homepage "https://github.com/nlf/dlite"
  url "https://github.com/nlf/dlite/archive/1.1.5.tar.gz"
  sha256 "cfbd99ef79f9657c2927cf5365ab707999a7b51eae759452354aff1a0200de3f"
  head "https://github.com/nlf/dlite.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cab7bd9704df6b1f162a7d258ba3807a9d00cef93395b9fe4b4837a635969692" => :el_capitan
    sha256 "d1244ccccc75ab8747a86c01aceeb25fee219617d9d4a2c3a3c6cd0bad45c0ee" => :yosemite
  end

  # DLite depends on the Hypervisor framework which only works on
  # OS X versions 10.10 (Yosemite) or newer
  depends_on :macos => :yosemite
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/nlf/dlite"
    path.install Dir["*"]

    cd path do
      system "make", "dlite"
      bin.install "dlite"
    end
  end

  def caveats
    <<-EOS.undent
      Installing and upgrading dlite with brew does not automatically
      install or upgrade the dlite daemon and virtual machine.
    EOS
  end

  test do
    output = shell_output(bin/"dlite version")
    assert_match version.to_s, output
  end
end
