class Kanata < Formula
  desc "Cross-platform software keyboard remapper for Linux, macOS and Windows"
  homepage "https://github.com/jtroo/kanata"
  url "https://github.com/jtroo/kanata/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "7081073d1d22fe4e404cf8e7d1dfa3f72562fb2d96538367c07f64877dcbf87a"
  license "LGPL-3.0-only"
  head "https://github.com/jtroo/kanata.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae04c41b6513e95f6af3a314c8eff4c1350f6b3277325a4e3009c52f7a779bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93140a2725b06daeed151c8d47aa77c5db2b083b70081437015160ce3aeffc74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7408702c3e805859bd7781dceffe8977860197ac5c1dcf8d5f87f5a8fcddaca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f8d6f9e8f5fd7d434968a5c24c1039089297a6c7072f372270afa5e1060cc4e"
    sha256 cellar: :any,                 arm64_linux:   "c1e3f33114e33735271c47df820293dcc9d4930f8c2bab848bcb090698881432"
    sha256 cellar: :any,                 x86_64_linux:  "50893ea6f72657b9ba4da720b43683d5d885a6e1d68644d03091352d70ee7d66"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"kanata", "--no-wait", "--cfg", "#{Dir.home}/.config/kanata/kanata.kbd"]
    keep_alive true
    require_root true
    working_dir Dir.home
    environment_variables PATH: std_service_path_env
    log_path var/"log/kanata.log"
    error_log_path var/"log/kanata.log"
  end

  test do
    (testpath/"kanata.kbd").write <<~LISP
      (defsrc
        caps grv         i
                    j    k    l
        lsft rsft
      )

      (deflayer default
        @cap @grv        _
                    _    _    _
        _    _
      )

      (deflayer arrows
        _    _           up
                    left down rght
        _    _
      )

      (defalias
        cap (tap-hold-press 200 200 caps lctl)
        grv (tap-hold-press 200 200 grv (layer-toggle arrows))
      )
    LISP

    system bin/"kanata", "--check"
  end
end
