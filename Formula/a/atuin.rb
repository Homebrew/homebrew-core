class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v17.0.0.tar.gz"
  sha256 "9c1bd5e180f53dd98248f582a36a4ead0670d3e155874a7217ec87cab3cea51a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2984f798a328374d647d9527c73c10a92d495e2084b119d77b7e924babc92b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "392fdb535b2794e6e7bb85450b077c1ee8bd071675f5909dd7f0cf34f22d9d7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb7ccc86a637a80584eb37d2651087d664e8d966d98748933ad6e2a516efe4ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5c015ebce8467fc97f84c07414c6e36d3ce96f1655d853dc720f9f4731c8345"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d16a1b69c4dc56e7977e18a191e16c3db8227423658bf56860280757b9c5f45"
    sha256 cellar: :any_skip_relocation, ventura:        "ca14080813173989b2ecb44d3bf997d4bc3d8bd65f010b64aa9c12a82e83595b"
    sha256 cellar: :any_skip_relocation, monterey:       "24ff553ba1828842f25e804d97b0070df24a0e022359a76872436c378dddc49c"
    sha256 cellar: :any_skip_relocation, big_sur:        "30658989180d9c364e304f3a3030e8e5d94a9d3e06c4aba11e353b0cb8c1d5ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342e14f3f2dae7783ca2ace4c4bd51ea856bf11abd65d359bae3c8e2892de0e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
