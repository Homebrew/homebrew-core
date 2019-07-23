class Crush < Formula
  desc "Data reduction and imaging pipeline for select astronomical cameras"
  homepage "https://www.sigmyne.com/crush"
  url "https://github.com/attipaci/crush/releases/download/2.50-1/crush-2.50-1.tar.gz"
  sha256 "e5c95d0dd2fa99a865ae04d6fe8260070cd8507f1cdcce6ad14aef35fba7963f"

  bottle :unneeded

  #depends_on ":java" => "1.8+"		# Any formula providing a java >= 1.8.0
  #depends_on "gnuplot" => :recommended

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Install the various bits and pieces to their proper locations
    share.install Dir["Install/posix/share/*"]
    man.install Dir["Install/posix/man/*"]
    doc.install Dir["Documentation/*"]
    doc.install [ "copyright", "license.txt" ]

    # Delete files installed elsewhere from #{pkgshare}
    pkgshare.rm_rf [ "Install", "Documentation" ]
	pkgshare.rm_f [ "copyright", "license" ]

    # Copy the rest of the distro into its final location in #{prefix}/share/crush
    pkgshare.install Dir["*"]

    # Create symlinks to the executables in #{bin} 
    bin.install_symlink "#{pkgshare}/crush"
    bin.install_symlink "#{pkgshare}/coadd"
    bin.install_symlink "#{pkgshare}/detect"
    bin.install_symlink "#{pkgshare}/esorename"
    bin.install_symlink "#{pkgshare}/histogram"
    bin.install_symlink "#{pkgshare}/difftool"
    bin.install_symlink "#{pkgshare}/imagetool"
    bin.install_symlink "#{pkgshare}/show"
  end

  test do
    system "#{bin}/crush"
  end
end
