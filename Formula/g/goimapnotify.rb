class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  url "https://gitlab.com/shackra/goimapnotify/-/archive/2.5.6/goimapnotify-2.5.6.tar.bz2"
  sha256 "d0e9b80a0284ad19ad94103f4c5be7004a6921b0b7fc9981e07094eaf74ca16b"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/shackra/goimapnotify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f95781ffbd87f18943ee5e89a71a16f54abf0369714bd772b7a1d82402d99dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95781ffbd87f18943ee5e89a71a16f54abf0369714bd772b7a1d82402d99dbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95781ffbd87f18943ee5e89a71a16f54abf0369714bd772b7a1d82402d99dbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a719ca0b44aae13f4f5565da2debd8bd0cad746c24414faed90d5b80331ac950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de795319b932c7e4f5dbb7fb83ac04999120d7a9ab1465b7ac4c0675e85720b0"
    sha256 cellar: :any,                 x86_64_linux:  "3b02ecd13d04763ebebacf077fad9e0fb3bee56d8f1c776a500429ae36ea1545"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/goimapnotify"
  end

  service do
    run [opt_bin/"goimapnotify"]
    keep_alive true
    log_path var/"log/goimapnotify.log"
    error_log_path var/"log/goimapnotify.log"
  end

  test do
    (testpath/"config.yml").write <<~YAML
      configurations:
        - username: test@example.com
    YAML

    output = shell_output("#{bin}/goimapnotify -conf #{testpath}/config.yml 2>&1", 1)
    assert_match "tag #{version}", output
    assert_match "empty or have invalid configuration format", output
  end
end
