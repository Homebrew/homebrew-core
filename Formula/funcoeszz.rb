class Funcoeszz < Formula
  desc "Dozens of command-line mini-applications (Portuguese)"
  homepage "https://funcoeszz.net/"
  url "https://funcoeszz.net/download/funcoeszz-18.3.sh"
  sha256 "c1348fbaf79e7ac97568785674edee602077c3a747d3a1bfa4cf63af343c4352"

  bottle :unneeded

  depends_on "bash"

  def install
    bin.install "funcoeszz-#{version}.sh" => "funcoeszz"
  end

  def caveats
    <<~EOS
      To use this software add to your profile:
        export ZZPATH="#{opt_bin}/funcoeszz"
        source "$ZZPATH"

      Usage of a newer Bash than the macOS default is required.
    EOS
  end

  test do
    assert_equal "15", shell_output("#{bin}/funcoeszz zzcalcula 10+5").chomp
  end
end
