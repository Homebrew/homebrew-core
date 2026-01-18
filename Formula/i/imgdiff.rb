class Imgdiff < Formula
  desc "Pixel-by-pixel image difference tool"
  homepage "https://github.com/n7olkachev/imgdiff"
  url "https://github.com/n7olkachev/imgdiff/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "e057fffbf9960caf90d69387d6bc52e4c59637d75b6ee19cbc40d8a3238877e4"
  license "MIT"
  head "https://github.com/n7olkachev/imgdiff.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "245066f106ba02042598e6735c482b506b45f82be5e583ee83f39c2afe5afcc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "353d0253fe941d4505520098a05f9be091e7c4cdd1ce77dd192f20b4021df88d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dde33cc03e6e8eabf007303fb1fbc66c6b84675d6397df4cce9d1c7540a7ce0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "942f3a737f90c494847592442d17fd383991ed92169fb96a5790ad689e519c6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "694271bcf10d42cdd17204aef241ba2ae68c7e0feb22a7d71435b5ac9895b7ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af67076130ef37bd88ce33a9702400cb8dffb66dc851b1ed1ff74a24044ab31f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4235fcb7927d3b4fb8fd45c808109b078b0ec61de7e468512a8b21f1e74925a"
    sha256 cellar: :any_skip_relocation, ventura:        "29720df056b9a1efc37bba9541506c34472f15e3a76e8e7c5da2bd72d9a76633"
    sha256 cellar: :any_skip_relocation, monterey:       "da646305519f434e028ef7ab1e1c8a53df4ce19444e7c54aaac8d92b78a34823"
    sha256 cellar: :any_skip_relocation, big_sur:        "050b20915575431bee1ec827bdbc497c7203cf80999fd926da0b89bd206ff0e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "38a86c696c71faaa5eab6ccd4f11989c31d5e571f4be2bbc3cf16459d85bd9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba0cd4c33ae5e8d1bc7a2cf32152c75c02b24e4477a3c674857b1547b43baec2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    test_image = test_fixtures("test.png")
    output = shell_output("#{bin}/imgdiff #{test_image} #{test_image}")
    assert_match "Images are equal", output
  end
end
