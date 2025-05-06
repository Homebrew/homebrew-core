class Pickle < Formula
  desc "PHP Extension installer"
  homepage "https://github.com/FriendsOfPHP/pickle"
  url "https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.11/pickle.phar"
  sha256 "fe68430bbaf01b45c7bf46fa3fd2ab51f8d3ab41e6f5620644d245a29d56cfd6"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f639f368ae43bb57ae421bbd3426bab6edc063da8f7ec66f53344c104073f430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f639f368ae43bb57ae421bbd3426bab6edc063da8f7ec66f53344c104073f430"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f639f368ae43bb57ae421bbd3426bab6edc063da8f7ec66f53344c104073f430"
    sha256 cellar: :any_skip_relocation, sonoma:        "91002e34b82efb2b8514339bfc45b0d0a0455dc8ba05c1ccd30fef75841914f7"
    sha256 cellar: :any_skip_relocation, ventura:       "91002e34b82efb2b8514339bfc45b0d0a0455dc8ba05c1ccd30fef75841914f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f1c4215357e0916796420abb44f644c492a3788993b0fcdab6e74a37843b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f639f368ae43bb57ae421bbd3426bab6edc063da8f7ec66f53344c104073f430"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "pickle.phar" => "pickle"
  end

  test do
    assert_match(/Package name[ |]+apcu/, shell_output("#{bin}/pickle info apcu"))
  end
end
