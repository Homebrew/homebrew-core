class Autocommitmsg < Formula
  desc "Your Intelligent Commit Message Assistant"
  homepage "https://github.com/Malnati/auto-commit-msg"
  url "https://github.com/Malnati/auto-commit-msg/archive/v0.1-alpha.tar.gz"

  def install
    ohai "Starting the installation process."

    # Check for existing installations using regex
    ohai "Checking for existing installations using regex."
    existing_install = `find #{HOMEBREW_PREFIX} -regex '.*auto[-_]commit[-_]msg.*'`.strip
    if !existing_install.empty?
      onoe "Existing installation found. Aborting."
      ohai "Please uninstall the existing version using: brew remove #{existing_install.split('/').last}"
      return
    end

    # Verify current directory
    current_dir = Dir.pwd
    ohai "Current directory before extraction: #{current_dir}"
    system "ls -alh || echo 'ls -alh failed.'"

    # Extract tarball and list contents
    ohai "Extracting tarball."
    result = system "tar -xzf #{cached_download}"
    ohai "Extraction result: #{result}"
    if !result
      ohai "Original error: Extraction failed."
      system "ls -alh || echo 'ls -alh failed.'"
    end

    # Update current directory variable
    current_dir = Dir.pwd
    ohai "Current directory after extraction: #{current_dir}"

    # Dynamically find the script path
    script_path = Dir.glob("**/auto-commit-msg/usr/local/bin/auto-commit-msg").first
    ohai "Script path before verification: #{script_path}"

    # Verify if the script exists
    if File.exist?(script_path)
      ohai "Script exists. Making it executable."
      result = system "chmod 0755 #{script_path}"
      ohai "chmod result: #{result}"
      if !result
        ohai "Original error: chmod failed."
        system "ls -alhR || echo 'ls -alhR failed.'"
      end
    else
      onoe "Script does not exist. Aborting."
      system "ls -alhR || echo 'ls -alhR failed.'"
      return
    end

    # Update script path variable
    ohai "Script path after verification: #{script_path}"

    # Move the script to the bin directory
    bin.install script_path
    ohai "Moved the script to #{bin}/#{script_path.split('/').last}"

    # Additional debugging steps
    system "ls -alh #{bin} || echo 'ls -alh failed.'"

    ohai "Installation process completed."
  end

  test do
    ohai "Running test."
    system "#{bin}/auto-commit-msg", "--version"
  end
end

