class AdrTools < Formula
  desc "CLI tool for working with Architecture Decision Records."
  homepage "https://github.com/npryce/adr-tools"
  url "https://github.com/npryce/adr-tools/archive/2.1.0.tar.gz"
  sha256 "1ef028cfeaa1b262a5c62845aa8965be169705370983f9ff73b17ec77bf75f70"

  def install
    # Override adr-config with custom config to point to homebrew dirs
    system "echo '#!/bin/bash' > src/adr-config"
    system "echo 'echo adr_bin_dir=\"#{bin}\"' >> src/adr-config"
    system "echo 'echo adr_template_dir=\"#{prefix}\"' >> src/adr-config"

    prefix.install Dir["src/*.md"] # Places the base templates in `prefix`
    bin.install Dir["src/*"]       # Copies the rest to `prefix/bin`
  end

  test do
    assert_match(/Run 'adr help COMMAND' for help on a specific command./,
                 pipe_output("#{bin}/adr help"))
  end
end
