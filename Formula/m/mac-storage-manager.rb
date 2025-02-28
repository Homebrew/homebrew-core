class MacStorageManager < Formula
  desc "Cross-platform tool to reclaim disk space by removing large applications"
  homepage "https://github.com/NarekMosisian/mac-storage-manager"
  url "https://github.com/NarekMosisian/mac-storage-manager/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "8f8364a9eb14fa56fe43cbf811bbcf6369d546d5227e2c6f523da8b7bce37e4b"
  license "AGPL-3.0-only"
  depends_on "jq"
  depends_on "newt"
  def install
    folder = "mac-storage-manager-2.0.0"
    folder = "." unless File.directory?(folder)
    cd folder do
      chmod 0755, "application_size_checker.sh"
      libexec.install "application_size_checker.sh"
      pkgshare.install "sounds" if File.directory?("sounds")
    end
    (bin/"mac-storage-manager").write <<~EOS
      #!/bin/sh
      export MAC_STORAGE_MANAGER_SHARE="#{pkgshare}"
      exec #{libexec}/application_size_checker.sh "$@"
    EOS
    (bin/"mac-storage-manager").chmod 0755
  end
  test do
    output = shell_output("#{bin}/mac-storage-manager --help")
    assert_match "Usage", output
  end
end
