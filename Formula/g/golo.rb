class Golo < Formula
  desc "Lightweight dynamic language for the JVM"
  homepage "https://golo-lang.org/"
  url "https://github.com/eclipse-archived/golo-lang/releases/download/release%2F3.4.0/golo-3.4.0.zip"
  sha256 "867c462a41a20e4b7dc1aef461b809d193a505c2a757477b147f0e30235bd545"
  license "EPL-2.0"
  head "https://github.com/eclipse-archived/golo-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "069c041fccb8a95fd9ea3c7a9c2105b384433a0e724d5b48812aa37d0d5c9f2d"
  end

  disable! date: "2023-10-16", because: :repo_archived

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

    rm(Dir["#{libexec}/bin/*.bat"])
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
    system bin/"golo", "golo", "--files", "#{libexec}/samples/helloworld.golo"
  end
end
