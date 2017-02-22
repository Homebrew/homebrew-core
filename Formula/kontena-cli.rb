class KontenaCli < Formula
  desc "Command-line client for Kontena container & microservices platform"
  homepage "https://kontena.io/"
  #url "https://github.com/kontena/kontena.git", :revision => "76931bb26b6467698673c62ce9ada884a517c615"
  url "https://github.com/kontena/kontena.git", :branch => "feature/brew_support"
  version '1.1.1'
  head "https://github.com/kontena/kontena.git"

  bottle :unneeded

  depends_on :ruby => "2.1"

  def install
    # avoid the outdated system ruby for now
    ruby_command = which_all("ruby").detect { |path| path.to_s != "/usr/bin/ruby" }
    gem_command = File.join(ruby_command.dirname, "gem")

    # Build the gem from sources and install it
    (buildpath/"cli").cd do
      system gem_command, "build", "--norc", "kontena-cli.gemspec"
      system gem_command,
        "install", Dir["kontena-cli-*.gem"].first,
        "--install-dir", buildpath/"out",
        "--no-env-shebang",
        "--no-wrappers",
        "--no-document"
    end

    exec_script = (buildpath/"out/bin/kontena").realpath
    inreplace exec_script, "#!/usr/bin/env ruby", "#!#{ruby_command}"
    bin.install exec_script

    rm_rf buildpath/"out/cache"
    libexec.install Dir["out/*"]

    zsh_completion.install buildpath/"cli/lib/kontena/scripts/kontena.zsh" => "_kontena"
    bash_completion.install buildpath/"cli/lib/kontena/scripts/kontena.bash" => "kontena"
  end

  def caveats
    unless Dir["/usr/local/{opt,var}/rbenv/shims/kontena"].empty?
      <<-EOS.undent
        You seem to use rbenv and have a previously installed kontena-cli that
        may get loaded instead of the homebrew installed version.

        To uninstall the previous installation copy and paste this into the
        terminal:

          for ruby in $(rbenv whence kontena); do \\
            rbenv shell $ruby; gem uninstall --force -a -x kontena-cli; \\
          done; \\
          rbenv rehash
      EOS
    end
  end

  test do
    assert_match "+homebrew", shell_output("#{bin}/kontena --version")
    assert_match "login", shell_output("#{bin}/kontena complete kontena master")
  end
end
