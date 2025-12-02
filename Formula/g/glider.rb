class Glider < Formula
  desc "Forward proxy with multiple protocols support"
  homepage "https://github.com/nadoo/glider"
  url "https://github.com/nadoo/glider/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "91aa9ad6d56b164b30abedc88a0d371b3af6ff96cfe92f18525fa8e110aaee1d"
  license "GPL-3.0-or-later"
  head "https://github.com/nadoo/glider.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e40af9870b9ee99ab0c80b8dae8d4d751e8c19f6f8bb09dbc4349f69c3d7158d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "69178a2d743839266c81d46c2da244ecd9079e0e45c2d6b7d4bda44be9f758bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a618322e9f26480347e3ca8109ac5fb9e07c40361842e41ba9f29ec651af3f5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d61e633784a9ab172b4f4e00840f469f29703fb85a0524a60ee76f6e3f62e8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8da5e672c3936b9e182bda3358b6e10c19ae4f11b4fd6d8e9efe35a5a9e05de"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cadbadff220b62c8c07db3672aea7160407b5b3e4f0b06e73cfc55285c6125a"
    sha256 cellar: :any_skip_relocation, ventura:        "254249a7b25bb02d6d21516eabbb0992e47030a8cf1570a7a11d433262e2583d"
    sha256 cellar: :any_skip_relocation, monterey:       "790df16eb1b61f3ac61d9619d9fe25e91309b4010504362f9a3b4343e73f7ff1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "589ee7459491b0c33f29de22537c31bd4ed337c34424c2d9a8681c03d109b925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66726d56a1303bd8f9aa06a36ae3694630a7ec53cf084dbf060ecfff2485767b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    etc.install buildpath/"config/glider.conf.example" => "glider.conf"
  end

  service do
    run [opt_bin/"glider", "-config", etc/"glider.conf"]
    keep_alive true
  end

  test do
    proxy_port = free_port
    glider = spawn bin/"glider", "-listen", "socks5://:#{proxy_port}"

    begin
      sleep 3
      output = shell_output("curl --socks5 127.0.0.1:#{proxy_port} -L https://brew.sh")
      assert_match "The Missing Package Manager for macOS (or Linux)", output
    ensure
      Process.kill 9, glider
      Process.wait glider
    end
  end
end
