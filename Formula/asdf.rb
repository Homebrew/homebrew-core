class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "a097d40888c276cb20e1489a3da6573dd9d184d8e6518c5f8177d3c2c1066f57"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2098bd4ff1da95064d7d112e8287532c077b1e1bda0dcb91fd977f7bac65ba5e"
  end

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    bash_completion.install "completions/asdf.bash"
    fish_completion.install "completions/asdf.fish"
    zsh_completion.install "completions/_asdf"
    libexec.install Dir["*"]
    touch libexec/"asdf_updates_disabled"

    bin.write_exec_script libexec/"bin/asdf"
  end

  def caveats
    s = "To use asdf, add the following line to your #{shell_profile}:\n"

    s += if preferred == :fish
      "  source #{opt_libexec}/asdf.fish\n\n"
    else
      "  . #{opt_libexec}/asdf.sh\n\n"
    end

    s += "Restart your terminal for the settings to take effect."

    s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "No plugins installed", output
    assert_match "Update command disabled.", shell_output("#{bin}/asdf update", 42)
  end
end
