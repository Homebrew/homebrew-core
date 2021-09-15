class Golo < Formula
  desc "Lightweight dynamic language for the JVM"
  homepage "https://golo-lang.org/"
  url "https://www.eclipse.org/downloads/download.php?file=/golo/golo-3.3.0.zip&r=1"
  sha256 "35df1aca1c7161a1a33855dbd8deafa8e4dbe9627f5f17a9211eae3db3486229"
  license "EPL-2.0"
  revision 2
  head "https://github.com/eclipse/golo-lang.git"

  livecheck do
    url "https://golo-lang.org/download/"
    regex(/href=.*?golo[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56c7edecb768b85203fceed00211d56196d49f18d2af60f7f5cb44d138eba3f2"
  end

  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    if build.head?
      system "./gradlew", "installDist"
      libexec.install %w[build/install/golo/bin build/install/golo/docs build/install/golo/lib]
    else
      libexec.install %w[bin docs lib]
    end
    libexec.install %w[share samples]

    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: "${JAVA_HOME:-#{ENV["JAVA_HOME"]}}"
    bash_completion.install "#{libexec}/share/shell-completion/golo-bash-completion"
    zsh_completion.install "#{libexec}/share/shell-completion/golo-zsh-completion" => "_golo"
    cp "#{bash_completion}/golo-bash-completion", zsh_completion
  end

  def caveats
    if ENV["SHELL"].include? "zsh"
      <<~EOS
        For ZSH users, please add "golo" in yours plugins in ".zshrc"
      EOS
    end
  end

  test do
    system "#{bin}/golo", "golo", "--files", "#{libexec}/samples/helloworld.golo"
  end
end
