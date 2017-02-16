class KontenaCli < Formula
  desc "Command-line client for Kontena container & microservices platform"
  homepage "https://kontena.io/"
  url "https://github.com/kontena/kontena/archive/v1.1.1.tar.gz"
  sha256 "e08e26a78e678eb0a1e5a2aa687829b9473a0c4744060b48e4a35050ebad0221"
  head "https://github.com/kontena/kontena.git"

  bottle :unneeded

  depends_on :ruby => "2.1"

  def install
    ruby_command = pick_a_ruby("2.1")
    gem_command = gem_for_ruby(ruby_command)

    # There's something strange in the way -g / --file works in gem install, seems to only work when you run it in the .gemspec directory.
    Dir.chdir buildpath/"cli" do
      system gem_command, "install", "-g", "--no-document", "--norc", "--without", "test,development", "--install-dir", buildpath/"cli/lib/vendor"
    end

    inreplace buildpath/"cli/bin/kontena" do |s|
      # Point to the picked ruby, "env ruby" can give you a different ruby otherwise
      s.gsub! "#!/usr/bin/env ruby", "#!#{ruby_command}"
      # Modify the GEM_PATH to load gems from the vendor directory
      s.gsub! "# add self to libpath", "# add vendor to gem path\nENV['GEM_PATH'] = '#{libexec}/vendor'\nGem.paths = ENV\n\n# add self to libpath"
      # Files in lib/ will be installed to brew's "libexec", so change the loadpath to point there
      s.gsub! "$:.unshift File.expand_path('../../lib', bin_file)", "$:.unshift '#{libexec}'"
    end

    # Same for the shell autocompleter
    inreplace buildpath/"cli/lib/kontena/scripts/completer",
      "#!/usr/bin/env ruby",
      "#!#{ruby_command}\n\n# add vendor to gem path\nENV['GEM_PATH'] = '#{libexec}/vendor'\nGem.paths = ENV\n\n"

    # Add a build tag to "kontena --version" string
    inreplace buildpath/"cli/lib/kontena/main_command.rb", "RUBY_PLATFORM +", "RUBY_PLATFORM + '+homebrew' +"

    # Patch completion init script
    inreplace buildpath/"cli/lib/kontena/scripts/init" do |s|
      s.gsub! "#!/usr/bin/env bash", "# Completion for kontena-cli"
      s.gsub! "DIR=$( cd \"$( dirname \"$src\" )\" && pwd )", "DIR=#{libexec}/kontena/scripts"
    end

    # The same script works for both shells. The original 'init' needs to exist in the directory or
    # kontena whois --bash-completion-path crashes.
    cp buildpath/"cli/lib/kontena/scripts/init", buildpath/"cli/lib/kontena/scripts/kontena.zsh"
    cp buildpath/"cli/lib/kontena/scripts/init", buildpath/"cli/lib/kontena/scripts/kontena.bash"

    # Create a "standard" loader for the completion function
    (buildpath/"cli/lib/kontena/scripts/_kontena").write(zsh_completer)
    zsh_completion.install buildpath/"cli/lib/kontena/scripts/_kontena" => "_kontena"

    bash_completion.install buildpath/"cli/lib/kontena/scripts/kontena.bash" => "kontena.bash"
    zsh_completion.install buildpath/"cli/lib/kontena/scripts/kontena.zsh" => "kontena.zsh"

    bin.install buildpath/"cli/bin/kontena"
    libexec.install Dir["cli/lib/*"]
    prefix.install buildpath/"cli/README.md"
    prefix.install buildpath/"CHANGELOG.md"
    # Required during operation:
    prefix.install buildpath/"cli/LOGO"
    prefix.install buildpath/"cli/VERSION"
  end

  test do
    assert_match "+homebrew", shell_output("#{bin}/kontena --version")
    assert_match "login", shell_output("#{libexec}/kontena/scripts/completer kontena master")
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
