class LinuxBootDoctor < Formula
  desc "Diagnose slow Linux boots from systemd-analyze evidence"
  homepage "https://github.com/adeshsuryan/linux-boot-doctor"
  url "https://github.com/adeshsuryan/linux-boot-doctor/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "979d1bf9c07c531e4dd8361200f8637d2b157276ea461e7fb744831f7d41a422"
  license "MIT"
  head "https://github.com/adeshsuryan/linux-boot-doctor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Cargo workspace: binary crate is crates/boot-doctor-cli
    system "cargo", "install", *std_cargo_args(path: "crates/boot-doctor-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linux-boot-doctor --version")

    # Offline fixture path works on macOS/Linux without systemd
    fixture = testpath/"boot"
    fixture.mkpath
    (fixture/"analyze-time.txt").write <<~EOS
      Startup finished in 267ms (userspace)
      multi-user.target reached after 260ms in userspace.
    EOS
    (fixture/"analyze-blame.txt").write <<~EOS
      47ms systemd-resolved.service
      25ms systemd-journald.service
    EOS
    (fixture/"analyze-critical-chain.txt").write <<~EOS
      multi-user.target @260ms
      ??basic.target @200ms
    EOS

    output = shell_output("#{bin}/linux-boot-doctor check --input #{fixture} --fail-on high")
    assert_match "Linux boot doctor", output
    assert_match "FINDINGS", output
  end
end
