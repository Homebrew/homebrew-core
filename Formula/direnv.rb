class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.13.2.tar.gz"
  sha256 "04fdbd3fe7ddf496a3da41cb6e767100d8d6f6b52fef9e2217c9e330b0e6257d"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5c47aaf4555aace5386f6cfa4ee76105271d01c6e470f27887349f42f332f4c3" => :high_sierra
    sha256 "71876677847d22b01698c45fc1b12174ee1ef78c10e294ba5a72d6984157a931" => :sierra
    sha256 "46de205de4bcb4bd5b196ee4164e84dfca156adb811fe56bea117933260600b9" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
