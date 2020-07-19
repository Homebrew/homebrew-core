class Golo < Formula
  desc "Lightweight dynamic language for the JVM"
  homepage "https://golo-lang.org/"
  url "https://bintray.com/artifact/download/golo-lang/downloads/golo-3.3.0.zip"
  sha256 "a9ff036518aee4280102b2d5b79752d8378857fd9714e5b701999a6c93b89316"
  license "EPL-2.0"
  revision 2
  head "https://github.com/eclipse/golo-lang.git"

  bottle :unneeded

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
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => "${JAVA_HOME:-#{ENV["JAVA_HOME"]}}"
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
