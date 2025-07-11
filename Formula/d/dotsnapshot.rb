class Dotsnapshot < Formula
  desc "Comprehensive dotfile and system configuration snapshot tool"
  homepage "https://github.com/tomerlichtash/dotsnapshot"
  url "https://github.com/tomerlichtash/dotsnapshot/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "YOUR_SHA256_HERE"  # You'll need to calculate this after creating the release
  license "MIT"
  head "https://github.com/tomerlichtash/dotsnapshot.git", branch: "main"

  depends_on "bash" => :recommended

  def install
    # Install the main script
    bin.install "dotsnapshot.sh" => "dotsnapshot"

    # Install library files
    lib.install Dir["lib/*"]

    # Install generators
    generators_dir = lib/"generators"
    generators_dir.mkpath
    generators_dir.install Dir["generators/*"]

    # Install configuration files
    config_dir = lib/"config"
    config_dir.mkpath
    config_dir.install Dir["config/*"]

    # Install test files
    test_dir = lib/"test"
    test_dir.mkpath
    test_dir.install Dir["test/*"]

    # Install scripts
    scripts_dir = lib/"scripts"
    scripts_dir.mkpath
    scripts_dir.install Dir["scripts/*"]

    # Install documentation
    doc.install "README.md", "CHANGELOG.md", "LICENSE.md"

    # Make scripts executable
    chmod 0755, bin/"dotsnapshot"
    chmod 0755, Dir[lib/"scripts/*"]
    chmod 0755, Dir[lib/"generators/*"]
    chmod 0755, Dir[lib/"test/*"]
  end

  def post_install
    # Create default configuration if it doesn't exist
    config_file = etc/"dotsnapshot/dotsnapshot.conf"
    unless config_file.exist?
      config_file.parent.mkpath
      config_file.write <<~EOS
        # DotSnapshot Configuration
        # This file was created by Homebrew installation

        # Snapshot target directory
        DSNP_SNAPSHOT_TARGET_DIR=".snapshots"

        # Backup retention period in days
        DSNP_BACKUP_RETENTION_DAYS=30

        # Logs directory
        DSNP_LOGS_DIR=".logs"

        # Whether to use machine-specific directories
        DSNP_USE_MACHINE_DIRECTORIES=true
      EOS
    end

    # Create generators configuration if it doesn't exist
    generators_config = etc/"dotsnapshot/generators.conf"
    unless generators_config.exist?
      generators_config.write <<~EOS
        # Snapshot Generators Configuration
        # This file was created by Homebrew installation

        # Array of available snapshot generators
        # Format: "script_name:display_name:description"
        SNAPSHOT_GENERATORS=(
            "generators/homebrew.sh:Brewfile:Creates a snapshot of Homebrew packages (Brewfile)"
            "generators/cursor-extensions.sh:Cursor Extensions:Creates a snapshot of Cursor extensions with versions"
            "generators/cursor-settings.sh:Cursor Settings:Creates a snapshot of Cursor's settings.json file"
            "generators/vscode-settings.sh:VS Code Settings:Creates a snapshot of VS Code's settings.json file"
            "generators/vscode-extensions.sh:VS Code Extensions:Creates a snapshot of VS Code extensions with versions"
        )
      EOS
    end
  end

  def caveats
    <<~EOS
      DotSnapshot has been installed!

      Configuration files are located at:
        #{etc}/dotsnapshot/

      To start using DotSnapshot:
        dotsnapshot --help
        dotsnapshot --list
        dotsnapshot

      For more information, see:
        #{doc}/README.md
    EOS
  end

  test do
    # Test that the command works
    assert_match "0.0.1", shell_output("#{bin}/dotsnapshot --version")

    # Test help command
    assert_match "Usage:", shell_output("#{bin}/dotsnapshot --help")

    # Test list command
    assert_match "Available snapshot generators:", shell_output("#{bin}/dotsnapshot --list")
  end
end 