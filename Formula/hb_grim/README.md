# Grim Reaper - Homebrew Package

**Death-defying data protection for macOS and Linux via Homebrew**

When data death comes knocking, Grim ensures resurrection is just a command away. Homebrew provides the easiest installation method for macOS and Linux users.

## 🚀 Quick Install

```bash
brew install grimreaper/tap/grim-reaper
```

## 📦 What is Homebrew?

Homebrew is the missing package manager for macOS and Linux, providing simple command-line installation of applications.

**Benefits for Grim Reaper:**
- ✅ One-command installation with all dependencies
- ✅ Automatic updates via `brew upgrade`
- ✅ Clean uninstallation
- ✅ Native macOS/Linux integration

## 🛠️ Installation

### Add Tap and Install
```bash
# Add Grim Reaper tap
brew tap grimreaper/tap

# Install latest version
brew install grim-reaper

# Verify installation
grim --version
```

### Alternative: Direct Install
```bash
# Install directly from formula URL
brew install https://raw.githubusercontent.com/cyber-boost/homebrew-grim/main/Formula/grim-reaper.rb
```

## 🔧 Management Commands

```bash
# Update to latest version
brew upgrade grim-reaper

# Reinstall if corrupted
brew reinstall grim-reaper

# Uninstall completely
brew uninstall grim-reaper

# List installed versions
brew list --versions grim-reaper
```

## 🎯 Homebrew Formula Features

- **Multi-language Build**: Compiles Go, Rust, and Node.js components
- **Dependency Management**: Auto-installs Python, Node, Go, and Rust
- **Environment Setup**: Configures GRIM_ROOT and environment variables
- **Script Permissions**: Makes all shell scripts executable
- **Graveyard Integration**: Sets up .graveyard directory structure

## 📥 What Gets Installed

```bash
/opt/homebrew/bin/grim                 # Main command
/opt/homebrew/Cellar/grim-reaper/      # Full installation
├── bin/                               # Compiled binaries
├── sh_grim/                          # Shell scripts
├── throne/                           # Command router
├── py_grim/                          # Python components
└── go_grim/                          # Go binaries
```

## 🔧 Configuration

Homebrew automatically sets up:
- `GRIM_ROOT=/opt/homebrew/Cellar/grim-reaper/<version>`
- `GRIM_LICENSE=FREE`
- `GRIM_REAPER=FALSE`

## 🎬 Usage Examples

```bash
# Basic backup
grim backup /Users/username/Documents

# Monitor system
grim monitor --interval 30

# Scan for threats
grim scan /Applications

# Check system health
grim health

# View configuration
grim config show
```

## 🔗 Links

- **Homebrew**: https://brew.sh
- **Grim Tap**: https://github.com/cyber-boost/homebrew-grim
- **Grim Documentation**: https://grim.so
- **Support**: https://github.com/cyber-boost/grim/issues

## 📋 Requirements

- macOS 10.15+ or Linux
- Homebrew installed
- 2GB free disk space for full installation

## 🐛 Troubleshooting

### Permission Issues
```bash
# Fix permissions
brew postinstall grim-reaper
```

### Clean Reinstall
```bash
# Remove completely and reinstall
brew uninstall --force grim-reaper
brew cleanup
brew install grim-reaper
```

### Check Formula
```bash
# Audit formula
brew audit grim-reaper

# Test formula
brew test grim-reaper
```

---

**🗡️ Grim Reaper via Homebrew - Native macOS/Linux data protection!** 