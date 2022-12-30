class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.15.1",
      revision: "4c426d73d1a7e8428a66eddd4fb98cc70ab1cff8"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b839fc04c63ad2c8e9286a6b32bad948e52c82d70ce115e08398a97a3e664e4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d91c344d00e14f0a3eef9a760ecbd811af663881fd826654014c708f7631b21d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5b6e8e48f3786d5aae588279a965ceec8bcb5ee40292d528f52b4505fcffde3"
    sha256 cellar: :any_skip_relocation, ventura:        "29a5e4d1b4dd906d06c343a3b53c181445b29d965aaf1a7a63d9965e1c9c9480"
    sha256 cellar: :any_skip_relocation, monterey:       "1b8079514497f84f6885bb9d66957756e550e03752183a73069a57815620f8d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0576fed1d9cd1352981930e098479a2265328622309b5e4a2fcba99b19b616e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f349505714c0055078dc0ac1b5dbabd69fe9d747883cdfced64068ef846cfc67"
  end

  on_macos do
    depends_on "ldc" => :build
  end

  on_linux do
    depends_on "dmd" => :build
  end

  def install
    target = OS.mac? ? "ldc" : "dmd"
    ENV.append "DFLAGS", "-fPIC" if OS.linux?
    system "make", target
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = fork do
      exec "#{bin}/dcd-server", "-p", port.to_s
    end
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system "#{bin}/dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
