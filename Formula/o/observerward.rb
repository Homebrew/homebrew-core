class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.9.7.tar.gz"
  sha256 "e86c5f4a6b17cb2419b7c22c3f0968d1da0083649215a8677b68701d7fe0a43e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "145e67fc5657be1d4a28b2513d685c09eb735bc23bb84143240a41709f66c5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c02752b94a04bc89cfa1b0c57e186ed7b539f797452819e734d6751b5c110d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "352909ccd9cc903c156b3726e275cb8552204a5f82248ac58dbc21681bc73c29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72752dc1df1d7e73d2fa5ecd463bcd25c083217115f53ba2f48cea2e4b950e41"
    sha256 cellar: :any_skip_relocation, sonoma:        "4955f464cb645785bbc87a45497ea4f345eaa14d365a95163b7377933834bea6"
    sha256 cellar: :any_skip_relocation, ventura:       "7079ca8fbcb5855cb28a7fbb556a5a6ed3c52e935fdc0d171019fbe588918c73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5bd96388491dbc39a46e3ba948f032f8f30342a04f657699dff0c8cc7f539f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "495063a906230fd6edf8c127be1ed5e25813377a60a0d927c2bcc127e3443e9a"
  end

  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
