class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro/releases/download/v1.4.1/micro-1.4.1-src.tar.gz"
  sha256 "0b516826226cf1ddf2fbb274f049cab456a5c162efe3d648f0871564fadcf812"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "f5176ac6e12e25b7b8c88965cc8d92fe0892f6eaec60c28359c3be3e2f460df0" => :mojave
    sha256 "863a1f4f3cb0f48efe6ca22a0df05cf2c9adcaf63857aea622f2e26e21836dc5" => :high_sierra
    sha256 "8426c70077cf223e6fb677de514ede5546c3635b9760da0c1980577c7b2dd016" => :sierra
    sha256 "73755f137c49c168bf9ccc817df71b067959609fa2dc3eabda8002fb8f253e67" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/zyedidia/micro").install buildpath.children

    cd "src/github.com/zyedidia/micro" do
      system "make", "build-quick"
      bin.install "micro"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
