class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "247c7c87481f38d7788c1fb1be12021c778676c0d0ab37e529ec528f87f487ce"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "957266f04bb63edbd0e5ef47a0b199d32f4ad6b5a79129aee3ffb2e5184468ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f010b93dbcd8ffe51c1815b810c3c97950559223bd86700f9d32bc56117e5cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c05e6a4ad18495b3139defd17badd933d015ab8e999ed027728eb1c948afe0a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e12009a260e5e4771ba681edd7580e19b7c1f19648ce0fcdab8e5f8d16681a94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7780bb54f22c281c204d04348c55eeedec49908552927e69ed5c23c48d5ba8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65fffb9cbaa31616c6b8fbc74d24103950e02ef009a9409c354b3598f3bbf36"
  end

  depends_on "rust" => :build

  def install
    ENV["ASCIINEMA_GEN_DIR"] = "."

    system "cargo", "install", *std_cargo_args

    man1.install Dir["man/**/*.1"]

    bash_completion.install "completion/asciinema.bash" => "asciinema"
    fish_completion.install "completion/asciinema.fish"
    zsh_completion.install "completion/_asciinema"
    pwsh_completion.install "completion/_asciinema.ps1" => "asciinema"
    (share/"elvish/lib").install "completion/asciinema.elv"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["ASCIINEMA_SERVER_URL"] = "https://example.com"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to authenticate this CLI", output
  end
end
