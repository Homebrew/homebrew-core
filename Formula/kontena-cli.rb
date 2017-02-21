class KontenaCli < Formula
  desc "Command-line client for Kontena container & microservices platform"
  homepage "https://kontena.io/"
  url "https://github.com/kontena/kontena/archive/v1.1.1.tar.gz"
  sha256 "e08e26a78e678eb0a1e5a2aa687829b9473a0c4744060b48e4a35050ebad0221"
  head "https://github.com/kontena/kontena.git"

  bottle :unneeded

  depends_on :ruby => "2.1"

  def install
    # avoid the outdated system ruby for now
    ruby_command = which_all("ruby").detect { |path| path.to_s != "/usr/bin/ruby" }
    gem_command = File.join(ruby_command.dirname, "gem")

    # Make --version indicate it is a HEAD build
    if build.head?
      inreplace (buildpath/"cli/VERSION"), /(\d+\.\d+\.\d+).*/, "\\1-head"
    else
      # If building from tar.gz sources, git ls-files obviously doesn't work
      inreplace buildpath/"cli/kontena-cli.gemspec",
        "`git ls-files -z`.split(\"\\x0\")",
        "Dir['LOGO', 'README.md', 'LICENSE.txt', 'VERSION','bin/*', 'lib/**/*']"
    end

    # Also add a "homebrew" build tag to "kontena --version" string
    inreplace buildpath/"cli/lib/kontena/main_command.rb",
      "RUBY_PLATFORM +",
      "RUBY_PLATFORM + '+homebrew' +"

    # Build the gem from sources and install it
    (buildpath/"cli").cd do
      system gem_command, "build", "--norc", "kontena-cli.gemspec"
      system gem_command,
        "install", Dir["kontena-cli-*.gem"].first,
        "--install-dir", buildpath/"out",
        "--no-env-shebang",
        "--no-wrappers",
        "--norc",
        "--no-document"
    end

    # Patch the exec script
    inreplace buildpath/"cli/bin/kontena" do |s|
      s.gsub! "#!/usr/bin/env ruby", "#!#{ruby_command}"
      s.gsub! "# add self to libpath", libexec_to_gem_path
    end
    bin.install buildpath/"cli/bin/kontena"

    # Same for autocompleter
    completer = buildpath/"cli/lib/kontena/scripts/completer"
    inreplace completer do |s|
      s.gsub! "#!/usr/bin/env ruby", "#!#{ruby_command}"
      s.gsub! "# add self to libpath", libexec_to_gem_path
      s.gsub! "require_relative '..", "require 'kontena"
    end
    chmod 0555, completer
    bin.install completer => "_kontena_completer"

    rm_rf buildpath/"out/cache"
    rm_rf buildpath/"out/bin"
    libexec.install Dir["out/*"]

    # Patch completion init script
    completion_init = buildpath/"cli/lib/kontena/scripts/init"
    inreplace completion_init do |s|
      s.gsub! "#!/usr/bin/env bash", "# Completion for kontena-cli"
      s.gsub! "${DIR}/completer", "#{bin}/_kontena_completer"
    end

    # The same script works for both shells.
    cp completion_init, buildpath/"cli/lib/kontena/scripts/kontena.zsh"
    cp completion_init, buildpath/"cli/lib/kontena/scripts/kontena.bash"

    bash_completion.install buildpath/"cli/lib/kontena/scripts/kontena.bash" => "kontena.bash"

    # Create a loader for the completion function
    (buildpath/"cli/lib/kontena/scripts/_kontena").write(zsh_completer)
    zsh_completion.install buildpath/"cli/lib/kontena/scripts/_kontena" => "_kontena"
    zsh_completion.install buildpath/"cli/lib/kontena/scripts/kontena.zsh" => "kontena.zsh"
  end

  def caveats
    unless Dir['/usr/local/{opt,var}/rbenv/shims/kontena'].empty?
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
    assert_match "login", shell_output("#{bin}/_kontena_completer kontena master")
  end

  private

  def libexec_to_gem_path
    <<-EOS.undent
      # add libexec to gem path
      ENV['GEM_PATH'] = '#{libexec}'
      Gem.paths = ENV

      # add self to libpath
    EOS
  end

  def zsh_completer
    <<-EOS.undent
      #compdef kontena
      _kontena () {
          local e
          e=$(dirname ${funcsourcetrace[1]%:*})/kontena.zsh
          if [ -f $e ]; then
              . $e
          fi
      }
    EOS
  end
end
