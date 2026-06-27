class Bk < Formula
  desc "Terminal EPUB Reader"
  homepage "https://github.com/aeosynth/bk"
  url "https://github.com/aeosynth/bk/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c720c8e81e86709f8543ca1a97a3c30b3bb33d55692a536cefed0ad2e3dfabcd"
  license "MIT"
  head "https://github.com/aeosynth/bk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "42cb86c453b9c30b09fd6d4cbec309748b0466a0de6cfbb9e5086c364d053e97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "30d3025706d0187e6cd460e507021a955c0530e1292a0b8432d56c79074fb07a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3643df6af656b1c215b983746a6982986e436f68ea5800e63b876579d24c2621"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1908ba16a3ab0d0ff9a23473cfa13429c8501f491f97315b447f1d2127d135f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b721741e74dfadfdaa8c138825f984752a0381349c89eadf22d5c416ad45e62"
    sha256 cellar: :any_skip_relocation, sonoma:         "8068f1d17daa139707c388f7941d5acd41f55a0d27d9e08c0b1f6e58b5667862"
    sha256 cellar: :any_skip_relocation, ventura:        "f69c8a364ee94f4ee85f8b9545235ed29b54c51eae5d709259cdb8547b1d3130"
    sha256 cellar: :any_skip_relocation, monterey:       "36744f668875bb46d8f30ad983ddd509dbef6ca0409be707c692a4a2e3fd1f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "501750e75de55c4246ae4ba053ab3852be696d1d63a0f9e052a1ebae2f5e13e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc14a838d10cc7fa1ceb15224041d836eb77d36bbda8c8a966afe158aabb2e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_epub = test_fixtures("test.epub")
    output = shell_output("#{bin}/bk --meta #{test_epub}")
    assert_match "language: en", output
  end
end
