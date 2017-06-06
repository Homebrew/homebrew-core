require "tmpdir"

class AzureCli2 < Formula
  include Language::Python::Virtualenv

  desc "Azure CLI 2.0"
  homepage "https://github.com/Azure/azure-cli"
  url "https://azurecliprod.blob.core.windows.net/releases/azure-cli_packaged_0.1.6.tar.gz"
  sha256 "bb4bd4694e044bf416941e3afdc505bde7d049bac2e66c8b3fe44c9cb3b57ff8"
  depends_on "python"

  # Apply the 'az component' patch
  patch do
    url "https://azurecliprod.blob.core.windows.net/patches/patch_2_component_custom.diff"
    sha256 "d61ef29ace9bbdfef9a25dfbb1f475225bbca174263c8f863ee70f87d0a78bbe"
  end

  # Apply pip module search patch
  patch do
    url "https://azurecliprod.blob.core.windows.net/patches/patch_2_pkg_util.diff"
    sha256 "4b97507cb73b405c6fb2d701eb52ffa72ce547f791097fccadffc491ad6ae194"
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

  test do
    bin_dir = libexec/"bin"
    system bin_dir/"az", "--version"
    assert_match "complete -o nospace -F _python_argcomplete az",
      shell_output("bash -c 'source #{bash_completion}/az.completion && complete -p az'")
  end
end
