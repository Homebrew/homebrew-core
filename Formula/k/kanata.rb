class Kanata < Formula
  desc "Cross-platform software keyboard remapper for Linux, macOS and Windows"
  homepage "https://github.com/jtroo/kanata"
  url "https://github.com/jtroo/kanata/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "c61ea1405e2822ee7c2ab151d8b6160b9061d8bd89abf7ce6abf0da1ce91cea5"
  license "LGPL-3.0-only"
  head "https://github.com/jtroo/kanata.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b16ab21cd2c8344f58be04bc0dbbcfb79b9b46eadf152cbf4bd363b07a7e55c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e06cef43db76ca8563a027a28359483c3650e2929e285c56e3f7cf76c188e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f3b8f58796a2a89da66c18db4a14e4eaca14fd2aecb3eebe3db5e8bfc7758ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b42e584acc0adf02f0c95a964d868efcdfbb68222714ee36cb1349e661f7bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d325f3217a52e939c3978733f3c3bccabf1350ae20dfed01f5d6e4916cd743a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4693e7e560389334ab01c417dcb7b245f7c53b4fa71ffa53585d41eeb9f5acc6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      Post Install Instructions:
      Please see instructions for MacOS at https://github.com/jtroo/kanata/releases

      1. Karabiner Driver
      This formula requires a specific version of the Karabiner driver to be installed.

      2. Permissions:
      This formula requires Accessibility and Input Monitoring permissions to function correctly.
      After installing, please grant these permissions in System Settings.

       Drag and drop the kanata binary: #{opt_bin}/kanata
       -> Into System Settings -> Privacy & Security -> Accessibility
      and
       -> System Settings -> Privacy & Security -> Input Monitoring
    EOS
  end

  service do
    require_root true
    run [opt_bin/"kanata", "--no-wait"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/kanata.log"
    log_path var/"log/kanata.log"
    working_dir Dir.home
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
