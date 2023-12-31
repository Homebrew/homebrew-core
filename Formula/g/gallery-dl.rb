class GalleryDl < Formula
  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/9e/f9/468f46582a76e9ef8b7373139aa43cb1e5b9e67f1a9c5ffa21d75b7c4735/gallery_dl-1.26.5.tar.gz"
  sha256 "5e51df08fc13832eba0a222f12efcd53c80d5df2e0fbc8bdf1a9e78327917c65"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abc39ac4d7212ea09624502b5be5c0f1d853484b9df836b983fa037403803a40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45c8b20a670fef897042c7df5a970788f47baf3d781d2a9978b180b84fd9bb7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fea08c4bfd16852c0a1a1835cab130a39f63fe69459cc454df84682f1b1fc403"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1e29f818fd4f725bda4d9bc7cfb4ed62087b712a16a7a9d0edbce24a448c293"
    sha256 cellar: :any_skip_relocation, ventura:        "2b5fc94fbbc542ae797e176666ae7f23431f46db2b4f42240563ff117778d7e4"
    sha256 cellar: :any_skip_relocation, monterey:       "def8a8ad8fad56595988ef68bf476183f0a9f948bc37a28d27ae40a344a586ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b02e1ea11dce179d7741abd5e06b747c3859e45df3eb00964ac89f6042b4b15f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
