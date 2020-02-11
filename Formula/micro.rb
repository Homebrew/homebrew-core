class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      :tag      => "v2.0.0",
      :revision => "399c6290768867351813250a6f1d8df7554917a5"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5176ac6e12e25b7b8c88965cc8d92fe0892f6eaec60c28359c3be3e2f460df0" => :mojave
    sha256 "863a1f4f3cb0f48efe6ca22a0df05cf2c9adcaf63857aea622f2e26e21836dc5" => :high_sierra
    sha256 "8426c70077cf223e6fb677de514ede5546c3635b9760da0c1980577c7b2dd016" => :sierra
    sha256 "73755f137c49c168bf9ccc817df71b067959609fa2dc3eabda8002fb8f253e67" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
