class Arcanist < Formula
  desc "Command-line interface for Phabricator"
  homepage "https://github.com/phacility/arcanist"

  stable do
    url "https://github.com/phacility/arcanist.git",
      :revision => "feb5f4d42c4fe0001e76428e80d5e88262308802"
    version "2019,week-25"

    resource "libphutil" do
      url "https://github.com/phacility/libphutil.git",
        :revision => "8df85007f38ecd06867582fa0539429a3ae83a37"
    end
  end

  head do
    url "https://github.com/phacility/arcanist.git"

    resource "libphutil" do
      url "https://github.com/phacility/libphutil.git"
    end
  end

  depends_on "php"

  def install
    resource("libphutil").stage do
      (libexec/"libphutil").install Dir["*"]
    end

    (libexec/"arcanist").install Dir["*"]
    bin.write_exec_script libexec/"arcanist/bin/arc"

    bash_completion.install_symlink libexec/"arcanist/resources/shell/bash-completion" => "arc"
    zsh_completion.install_symlink libexec/"arcanist/resources/shell/bash-completion" => "_arc"
  end

  test do
    system "git", "init"
    (testpath/".arcconfig").write <<~EOS
      {"editor": "vim"}
    EOS
    assert_match "vim", shell_output("#{bin}/arc get-config editor")
  end
end
