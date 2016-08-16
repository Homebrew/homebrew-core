class AdrTools < Formula
  desc "CLI tool for working with Architecture Decision Records."
  homepage "https://github.com/npryce/adr-tools"
  url "https://github.com/npryce/adr-tools/archive/1.2.0.tar.gz"
  sha256 "3f45646c099ae996b97c855a9a27ed540e076580eba59c2e8613453b7a67e412"
  head "https://github.com/npryce/adr-tools.git"

  def install
    inreplace "src/config.sh" do |s|
      s.gsub! 'adr_bin_dir="$(dirname $0)"', "adr_bin_dir=\"#{bin}\""
      s.gsub! 'adr_template_dir="$adr_bin_dir"', "adr_template_dir=\"#{prefix}\""
    end

    inreplace Dir["src/adr-*"], 'source "$(dirname $0)/config.sh"', "source '#{prefix}/config.sh'"
    inreplace Dir["src/_adr_*"], 'source "$(dirname $0)/config.sh"', "source '#{prefix}/config.sh'"

    inreplace "src/adr" do |s|
      s.gsub! 'source "$(dirname $0)/config.sh"', "source '#{prefix}/config.sh'"
      s.gsub! "cmd=$(dirname $0)/adr-$1", "cmd=$adr_bin_dir/adr-$1"
    end

    prefix.install Dir["src/*.md"]
    prefix.install Dir["src/config.sh"]
    bin.install Dir["src/*"] - Dir["src/*.md"] - Dir["src/config.sh"]
  end

  test do
    system "true"
  end
end
