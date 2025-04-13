class MixCompletion < Formula
  desc "Elixir Mix completion plus shortcuts/colors"
  homepage "https://github.com/davidhq/mix-power-completion"
  url "https://github.com/davidhq/mix-power-completion/archive/refs/tags/0.8.2.tar.gz"
  sha256 "0e3e94b199f847926f3668b4cebf1b132e63a44d438425dd5c45ac4a299f28f3"
  head "https://github.com/davidhq/mix-power-completion.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c07b1060823fba51931d64cdd01ff90ec6b03ba5f0bd6b41406456e0343e389b"
  end

  disable! date: "2024-08-10", because: :no_license

  def install
    bash_completion.install "mix"
  end

  test do
    assert_match "-F _mix",
      shell_output("bash -c 'source #{bash_completion}/mix && complete -p mix'")
  end
end
