class BrewCaskCompletion < Formula
  desc "Fish completion for brew-cask"
  homepage "https://github.com/xyb/homebrew-cask-completion"
  url "https://github.com/xyb/homebrew-cask-completion/archive/refs/tags/v2.1.tar.gz"
  sha256 "27c7ea3b7f7c060f5b5676a419220c4ce6ebf384237e859a61c346f61c8f7a1b"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/xyb/homebrew-cask-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "713823d99d3c5d3b927159496e1f71721870ac4480c508edefc4feb617df854d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1c72424ca568a228443546a65b49434e69e1c5b1388786281cb7cc3ec5413ecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9918f7a001ce1fb6bb7817a3aacae658371039789f5243d17e8a326880732d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb88b0184cc69f44b9c0e9744a4ce7a46685aea6e1e529deae45f5edd4497788"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb88b0184cc69f44b9c0e9744a4ce7a46685aea6e1e529deae45f5edd4497788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a058f8dd7fb25aa2ca8452d32f7d419b3b461b0f3b1dfe4f2f2e6d0e79b014ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "7881b953ee0b074dcf98d507dd637f805c2d04de803822ba2e002b00b9519ce1"
    sha256 cellar: :any_skip_relocation, ventura:        "2154b23c163900381ba68cfc78f2d961f5599e3a7116368ad516a7b02e2b7b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "2154b23c163900381ba68cfc78f2d961f5599e3a7116368ad516a7b02e2b7b4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5256bbd0456fc15083d843e7cc3778fd45dfd3562b14bf076e0a08bcc04948a"
    sha256 cellar: :any_skip_relocation, catalina:       "a5256bbd0456fc15083d843e7cc3778fd45dfd3562b14bf076e0a08bcc04948a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cfa441fcc60e4cab5a4005009c18f286d160b9e515462ab3938d8a15509d5195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3225d50a5098677d66fd4179c7fb07460129e158fc7f3ba4f1a35adb6bd8901e"
  end

  deprecate! date: "2025-05-17", because: "is now natively supported by `brew`"

  def install
    fish_completion.install "brew-cask.fish"
  end

  test do
    assert_path_exists fish_completion/"brew-cask.fish"
  end
end
