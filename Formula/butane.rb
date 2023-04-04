class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.18.0.tar.gz"
  sha256 "20d50bb7de12f730bd99b43f2121bc162fc3b5961fd1c0d4fd927c69802e321f"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8525d45c1a4104e1c591d11b28774021afaec713c375190fafdcee1ab959ca00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8525d45c1a4104e1c591d11b28774021afaec713c375190fafdcee1ab959ca00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8525d45c1a4104e1c591d11b28774021afaec713c375190fafdcee1ab959ca00"
    sha256 cellar: :any_skip_relocation, ventura:        "dffc4ee6a6b8658b268db6328d21af8242ce791c41390e37da3a8c1236bc5a2d"
    sha256 cellar: :any_skip_relocation, monterey:       "dffc4ee6a6b8658b268db6328d21af8242ce791c41390e37da3a8c1236bc5a2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dffc4ee6a6b8658b268db6328d21af8242ce791c41390e37da3a8c1236bc5a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92bf0b013613b80c7af330f1a5cff12cb0c099897aa6b859510bdb554d727f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor",
      *std_go_args(ldflags: "-w -X github.com/coreos/butane/internal/version.Raw=#{version}"), "internal/main.go"
  end

  test do
    (testpath/"example.bu").write <<~EOS
      variant: fcos
      version: 1.3.0
      passwd:
        users:
          - name: core
            ssh_authorized_keys:
              - ssh-rsa mykey
    EOS

    (testpath/"broken.bu").write <<~EOS
      variant: fcos
      version: 1.3.0
      passwd:
        users:
          - name: core
            broken_authorized_keys:
              - ssh-rsa mykey
    EOS

    system "#{bin}/butane", "--strict", "--output=#{testpath}/example.ign", "#{testpath}/example.bu"
    assert_predicate testpath/"example.ign", :exist?
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip)

    output = shell_output("#{bin}/butane --strict #{testpath}/example.bu")
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip)

    shell_output("#{bin}/butane --strict --output=#{testpath}/broken.ign #{testpath}/broken.bu", 1)
    refute_predicate testpath/"broken.ign", :exist?

    assert_match version.to_s, shell_output("#{bin}/butane --version 2>&1")
  end
end
