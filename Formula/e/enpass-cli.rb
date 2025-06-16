class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  stable do
    url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.6.4.tar.gz"
    sha256 "fc340d3a8010d825c73108da01041483b963de7d0ad92eb84f1c94778cfc35fc"

    # go.mod patch, upstream pr ref, https://github.com/hazcod/enpass-cli/pull/149
    patch do
      url "https://github.com/hazcod/enpass-cli/commit/5a05082040232baad0d76c32f24095307944255f.patch?full_index=1"
      sha256 "1d19226d307cda611a22d55b5bfdbc082df42d54ecf0490d72f5da42e6e0e437"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880a2e628a2ed9f9647e85584c5d4acdf8065514989622830cced35316df2c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "099e34647f3ef84b53e9b4854e6d71f8490fff3d52d435f196b89deba5c0f945"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d9709ca6f4b7eea51f811278af7844a9dd7b1153c48e5c137f1c96d439b3145"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8e71c2c817dae86f109d86f36e22995302c5306578058f8f5ee5ac5aaaeabb0"
    sha256 cellar: :any_skip_relocation, ventura:       "cc4b8e65919630811c6e6ae26e433d9a77cea6323e481153fac72b93ea9fd9c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfd20950ddbb4fef55f430f36c6f9f2239a23aa8140e3343134775f6805b9ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50f075ca060a7ab81a6d247b3a392ce91ffbcbf436145ee38e5fe5cc07781d89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=#{version}'"), "./cmd/enpasscli"
    pkgshare.install "test/vault.json", "test/vault.enpassdb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/enpass-cli version 2>&1")

    # Get test vault files
    mkdir "testvault"
    cp [pkgshare/"vault.json", pkgshare/"vault.enpassdb"], "testvault"
    # Master password for test vault
    ENV["MASTERPW"]="mymasterpassword"
    # Retrieve password for "myusername" from test vault
    assert_match "mypassword", shell_output("#{bin}/enpass-cli -vault testvault/ pass myusername")
  end
end
