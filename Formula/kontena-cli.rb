class KontenaCli < Formula
  desc "Command-line client for Kontena container & microservices platform"
  homepage "https://kontena.io/"
  url "https://github.com/kontena/kontena/archive/v1.1.1.tar.gz"
  sha256 "e08e26a78e678eb0a1e5a2aa687829b9473a0c4744060b48e4a35050ebad0221"
  head "https://github.com/kontena/kontena.git"

  bottle :unneeded

  option "with-ruby-autodiscovery", "Select a Ruby interpreter on every run instead of linking to the Ruby used during installation"
  option "with-development", "Install development libraries"

  depends_on :ruby => "2.1"

  def install
    # The depends_on :ruby is a bit flawed. It will validate that a ruby with version >= X exists
    # but does not patch PATH to return that one
    ruby_command = pick_a_ruby("2.1")
    gem_command = gem_for_ruby(ruby_command)

    # Make --version indicate it is a HEAD build
    inreplace (buildpath/"cli/VERSION"), /(\d+\.\d+\.\d+).*/, "\\1-head" if build.head?

    # Also add a "homebrew" build tag to "kontena --version" string
    inreplace buildpath/"cli/lib/kontena/main_command.rb", "RUBY_PLATFORM +", "RUBY_PLATFORM + '+homebrew' +"

    # If building from tar.gz sources, git ls-files obviously doesn't work
    unless build.head?
      inreplace buildpath/"cli/kontena-cli.gemspec", "`git ls-files -z`.split(\"\\x0\")", "Dir['LOGO', 'README.md', 'LICENSE.txt', 'VERSION','bin/*', 'lib/**/*']"
    end

    # Build the gem from sources and install it and its dependencies to buildpath/out
    Dir.chdir buildpath/"cli" do
      system gem_command, "build", "--norc", "kontena-cli.gemspec"
      install_args = ["install", Dir["kontena-cli-*.gem"].first, "--install-dir", buildpath/"out", "--no-env-shebang", "--no-wrappers", "--norc", "--no-document"]
      install_args << "--development" if build.with?("development")
      system gem_command, *install_args
    end

    # Patch the exec script
    inreplace buildpath/"cli/bin/kontena" do |s|
      s.gsub! "#!/usr/bin/env ruby", build.with?("ruby-autodiscovery") ? adaptive_shebang : "#!#{ruby_command}"
      s.gsub! "# add self to libpath", "# add libexec to gem path\nENV['GEM_PATH'] = '#{libexec}'\nGem.paths = ENV\n\n# add self to libpath"
    end
    bin.install buildpath/"cli/bin/kontena"

    # Same for autocompleter
    inreplace buildpath/"cli/lib/kontena/scripts/completer" do |s|
      s.gsub! "#!/usr/bin/env ruby", build.with?("ruby-autodiscovery") ? adaptive_shebang : "#!#{ruby_command}"
      s.gsub! "# add self to libpath", "# add libexec to gem path\nENV['GEM_PATH'] = '#{libexec}'\nGem.paths = ENV\n\n# add self to libpath"
      s.gsub! "require_relative '..", "require 'kontena"
    end
    bin.install buildpath/"cli/lib/kontena/scripts/completer" => "_kontena_completer"

    rm_rf buildpath/"out/cache"
    rm_rf buildpath/"out/bin"
    libexec.install Dir["out/*"]

    # Patch completion init script
    inreplace buildpath/"cli/lib/kontena/scripts/init" do |s|
      s.gsub! "#!/usr/bin/env bash", "# Completion for kontena-cli"
      s.gsub! "${DIR}/completer", "#{bin}/_kontena_completer"
    end

    # The same script works for both shells.
    cp buildpath/"cli/lib/kontena/scripts/init", buildpath/"cli/lib/kontena/scripts/kontena.zsh"
    cp buildpath/"cli/lib/kontena/scripts/init", buildpath/"cli/lib/kontena/scripts/kontena.bash"

    bash_completion.install buildpath/"cli/lib/kontena/scripts/kontena.bash" => "kontena.bash"

    # Create a loader for the completion function
    (buildpath/"cli/lib/kontena/scripts/_kontena").write(zsh_completer)
    zsh_completion.install buildpath/"cli/lib/kontena/scripts/_kontena" => "_kontena"
    zsh_completion.install buildpath/"cli/lib/kontena/scripts/kontena.zsh" => "kontena.zsh"
  end

  test do
    assert_match "+homebrew", shell_output("#{bin}/kontena --version")
    assert_match "login", shell_output("#{bin}/_kontena_completer kontena master")
  end

  private

  # Finds a ruby from the available rubies that satisfies min_version
  # Prefers a brew installed ruby that comes from Formula["ruby"]
  # Next in line is the ruby that comes from which("ruby")
  # Finally try any ruby found by which_all("ruby")
  #
  # Dies if no suitable ruby found.
  #
  # @param min_version [String]
  # @return path_to_ruby [String]
  def pick_a_ruby(min_version)
    min = Version.create(min_version)
    rubies = []

    brew_ruby = Formula["ruby"]
    rubies += Dir[brew_ruby.bin/"ruby*"] if brew_ruby.installed?

    rubies << which("ruby")

    rubies += which_all("ruby").map(&:to_s)

    found_ruby = rubies.detect do |ruby|
      version = Utils.popen_read(ruby, "-e", "puts RUBY_VERSION").strip
      version =~ /^\d+\.\d+/ && Version.create(version.to_s) >= min
    end

    odie "Can not find a satisfying ruby version" unless found_ruby
    found_ruby
  end

  # Finds the gem executable for the specified ruby
  # Dies if not found
  #
  # @param path_to_ruby [String]
  # @return path_to_gem [String]
  def gem_for_ruby(ruby_path)
    from_ruby_path = Dir[File.expand_path("../gem*", ruby_path)].first
    return from_ruby_path if from_ruby_path

    from_path = which_all("gem").detect { |gem| Utils.popen_read(gem, "env").include?("RUBY EXECUTABLE: #{ruby_path}") }
    return from_path if from_path

    odie "Can not find a rubygems gem executable for ruby #{ruby_path}"
  end

  def adaptive_shebang
    <<-EOS.undent
      #!/bin/sh
      for ruby in $(which -a ruby); do
        if $ruby -e "exit 1 if RUBY_VERSION < '2.1'"; then
          exec $ruby -x "$0" "$@"
        fi
      done
      echo "No suitable ruby 2.1+ interpreter found" >&2
      exit 1
      #!ruby
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
