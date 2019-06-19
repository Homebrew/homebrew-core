class Poetry < Formula
  desc "Python dependency management and packaging made easy"
  homepage "https://poetry.eustace.io"
  url "https://github.com/sdispater/poetry/releases/download/0.12.16/poetry-0.12.16-darwin.tar.gz"
  sha256 "63f30bc5ef15333f4c638dd82e036fa2425f48b6e3ba0fec515b8f77d63b86c6"

  resource "install_script" do
    url "https://raw.githubusercontent.com/sdispater/poetry/0.12.16/get-poetry.py"
    sha256 "5c9ea1d3dff0e04369443d38f214e051dc0fc2ea180e706d6b6c368b28ac7f4a"
  end

  def install
    # This is a complete bundle of all the application dependencies
    (lib/"poetry").install Dir["*"]
    resource("install_script").stage do
      # Extract binary stub from installer script
      system "python", "-c", "with open('poetry', 'w') as out_file: out_file.write(__import__('get-poetry').BIN)"
      bin.install "poetry"
    end
    # Write completions
    [
      ["bash", bash_completion/"poetry"],
      ["fish", fish_completion/"poetry.fish"],
      ["zsh", zsh_completion/"_poetry"],
    ].each do |shell, completion|
      completion.write Utils.popen_read("python #{bin}/poetry completions #{shell}")
    end
  end

  test do
    assert_match "Poetry 0.12.16", shell_output("#{bin}/poetry")
    system "#{bin}/poetry", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_predicate testpath/"test/pyproject.toml", :exist?
  end
end
