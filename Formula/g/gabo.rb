class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "5eb99893fd84194a17e824cc4629d42cdf1b618e37a537895eefc5a494a21325"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccc8fada8e1d9e4dd94061f0a6a16a2b5dbde7fbb6730d1fb511743e6afdccda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccc8fada8e1d9e4dd94061f0a6a16a2b5dbde7fbb6730d1fb511743e6afdccda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccc8fada8e1d9e4dd94061f0a6a16a2b5dbde7fbb6730d1fb511743e6afdccda"
    sha256 cellar: :any_skip_relocation, sonoma:        "53a32b8de2fc3bf5448b3343012b25c587bc4459b804e8d47e5d394bbdfefebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb7e27fb724dbe7ae8fdf608d399ff1332c78a73e20b4c7ca570492845ff39c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14c2011da45047e8d2efc413306cd89e6017132c398902e05fcbb5a624754f7c"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_path_exists gabo_test/".github/workflows/lint-yaml.yaml"
  end
end
