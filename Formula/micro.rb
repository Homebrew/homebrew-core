class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.8",
      revision: "cfcb2e4577fe00e744d5684c0871fd8ce849930c"
  license "MIT"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7bbc1f23f22346da2366262eda3926f1c624ae90762df86a4628a66cf219b7f" => :catalina
    sha256 "66885494019e07b69b073bcb32941146d8bb2cd07e0267fe75642202f7070817" => :mojave
    sha256 "64ea3aefee3f6c8d9bf9650ff9ce892369cd253c7bb1a77cbfbb46bdc6088111" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
