require "tmpdir"

class AzureCli2 < Formula
  include Language::Python::Virtualenv

  desc "Azure CLI 2.0"
  homepage "https://github.com/Azure/azure-cli"
  url "https://azurecliprod.blob.core.windows.net/releases/azure-cli_packaged_0.1.5.tar.gz"
  sha256 "cb65651530544c43343e2c80b0d96a681ad0a07367e288ef9fae261093c497f3"
  depends_on "python"

  # Apply the 'az component' patch
  patch do
    url "https://azurecliprod.blob.core.windows.net/homebrew/azure_cli_homebrew_patch_component_0.1.5_custom.diff"
    sha256 "674819102cfb112bc5c150c2dd5a1316d8b2c456f6af94a2c5f17240b35c14c3"
  end

  # Apply pip module search patch
  patch do
    url "https://azurecliprod.blob.core.windows.net/homebrew/azure_cli_homebrew_patch_pkg_util_0.1.5.diff"
    sha256 "f5993264c11e57a08263bb6221925710a213564403ff84877d5c89f273a907d0"
  end

  def completion_script; <<-EOS.undent
    _python_argcomplete() {
        local IFS='\v'
        COMPREPLY=( $(IFS="$IFS"                   COMP_LINE="$COMP_LINE"                   COMP_POINT="$COMP_POINT"                   _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS"                   _ARGCOMPLETE=1                   "$1" 8>&1 9>&2 1>/dev/null 2>/dev/null) )
        if [[ $? != 0 ]]; then
            unset COMPREPLY
        fi
    }
    complete -o nospace -F _python_argcomplete "az"
    EOS
  end

  def install
    virtualenv_create(libexec)
    Dir.mktmpdir do |tmp_dir|
      pkg_dirs = ["src/azure-cli", "src/azure-cli-core", "src/azure-cli-nspkg"]
      pkg_dirs += Dir.glob("src/command_modules/azure-cli-*/")
      # Build the packages
      pkg_dirs.each do |item|
        Dir.chdir(item) { system libexec/"bin/python", "setup.py", "bdist_wheel", "-d", tmp_dir }
      end
      # Install the CLI (with required modules only)
      system libexec/"bin/pip", "install", "azure-cli", "-f", tmp_dir
    end
    # Write the executable
    bin_dir = libexec/"bin"
    File.write("#{bin_dir}/az", "#!/usr/bin/env bash\n#{bin_dir}/python -m azure.cli \"$@\"")
    bin.install_symlink "#{libexec}/bin/az"
    # Bash tab completion
    File.write(libexec/"az.completion", completion_script)
    bash_completion.install libexec/"az.completion"
  end

  def caveats; <<-EOS.undent
    To complete tab completion set up:
      1. Modify your ~/.bash_profile (if the line doesn't already exist)
        $ echo "[ -f #{HOMEBREW_PREFIX}/etc/bash_completion.d/az.completion ] && . #{HOMEBREW_PREFIX}/etc/bash_completion.d/az.completion" >> ~/.bash_profile
      2. Restart your shell
        $ exec -l $SHELL
    ----
    Get started with:
      $ az configure
    EOS
  end

  test do
    bin_dir = libexec/"bin"
    system bin_dir/"az", "--version"
    assert_match "complete -o nospace -F _python_argcomplete az",
      shell_output("bash -c 'source #{bash_completion}/az.completion && complete -p az'")
  end
end
