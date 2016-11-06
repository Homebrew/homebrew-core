class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.1.3.tar.gz"
  sha256 "7fc530da947b31ba3a60e74a065deac5a88cb1a4c34dc7835998645816894af1"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecae4943c3a6a2827c8d34cc75173f0ac816c2221ecab05804f88b8c48a849d4" => :sierra
    sha256 "7020a17bdbe63f9685c4e3e8407599f41faa1484572103bdc8e73f524cef7e15" => :el_capitan
    sha256 "816e9831e6f00e9f919cb2c5e2b0744f12d32ab846e0627d8a1ed89b2180287f" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/iron-io/ironcli"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"iron"
    end
  end

  test do
    system bin/"iron", "-help"
  end
end
