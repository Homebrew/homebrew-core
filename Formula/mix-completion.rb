class MixCompletion < Formula
  desc "Elixir Mix completion plus shortcuts/colors"
  homepage "https://github.com/davidhq/mix-power-completion"
  url "https://github.com/davidhq/mix-power-completion/archive/0.8.2.tar.gz"
  sha256 "0e3e94b199f847926f3668b4cebf1b132e63a44d438425dd5c45ac4a299f28f3"
  head "https://github.com/davidhq/mix-power-completion.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "faa9e0edf1a9e4aac06ea640bfa2ff4ee4b6e81d086c33cd3aa999ef77b54a55"
  end

  def install
    bash_completion.install "mix"
  end

  test do
    assert_match "-F _mix",
      shell_output("source #{bash_completion}/mix && complete -p mix")
  end
end
