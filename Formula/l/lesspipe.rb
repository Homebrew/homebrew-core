class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://lesspipe.org"
  url "https://github.com/wofr06/lesspipe/archive/refs/tags/v2.30.tar.gz"
  sha256 "c54867a84b91acce772d24728c97c142b4b9a02034e322ed2d2a5755745b621d"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # sxw2txt
    "MIT", # code2color
    any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"], # vimcolor
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efb2eefb7282528298f9bfbb19ac2017f10788d2be86c898f89a2f62999a6458"
  end

  uses_from_macos "zsh" => :build # needed to guarantee installation of zsh completions
  uses_from_macos "perl"

  on_macos do
    depends_on "bash"
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}", "--shell=bash"
    system "make", "install"
  end

  def caveats
    <<~EOS
      add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_path_exists testpath/"homebrew.tar.gz"
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end
