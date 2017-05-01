class AdrTools < Formula
  desc "CLI tool for working with Architecture Decision Records."
  homepage "https://github.com/npryce/adr-tools"
  url "https://github.com/npryce/adr-tools/archive/2.1.0.tar.gz"
  sha256 "1ef028cfeaa1b262a5c62845aa8965be169705370983f9ff73b17ec77bf75f70"

  def install
    inreplace "src/adr-config" do |s|
      s.sub! "# Config for when running from the source directory.", "#!/bin/bash"
      s.sub! %q('"$(dirname $0)"'), bin
      s.sub! %q('"$(dirname $0)"'), prefix
    end

    prefix.install Dir["src/*.md"]
    bin.install Dir["src/*"]
  end

  test do
    assert_match(/0001-record-architecture-decisions.md/, shell_output("#{bin}/adr-init"))
    assert_match(/0001-record-architecture-decisions.md/, shell_output("#{bin}/adr-list"))
  end
end
