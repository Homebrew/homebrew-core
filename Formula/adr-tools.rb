class AdrTools < Formula
  desc "CLI tool for working with Architecture Decision Records"
  homepage "https://github.com/npryce/adr-tools"
  url "https://github.com/npryce/adr-tools/archive/3.0.0.tar.gz"
  sha256 "9490f31a457c253c4113313ed6352efcbf8f924970a309a08488833b9c325d7c"

  bottle :unneeded

  def install
    config = buildpath/"src/adr-config"

    # Unlink and re-write to matches homebrew's installation conventions
    config.unlink
    config.write <<~EOS
      #!/bin/bash
      echo 'adr_bin_dir=\"#{bin}\"'
      echo 'adr_template_dir=\"#{prefix}\"'
    EOS

    prefix.install Dir["src/*.md"]
    bin.install Dir["src/*"]
    bash_completion.install "autocomplete/adr" => "adr-tools"
  end

  test do
    file = "0001-record-architecture-decisions.md"
    assert_match file, shell_output("#{bin}/adr-init")
    assert_match file, shell_output("#{bin}/adr-list")
  end
end
