class Camilladsp < Formula
  desc "Flexible cross-platform IIR and FIR engine for crossovers, room correction etc"
  homepage "https://github.com/HEnquist/camilladsp"
  url "https://github.com/HEnquist/camilladsp/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "7e2fdca1e9c73885426ac889d27682c76d49ea1ea52c5f5bfe5356d7fdfa52df"
  license any_of: ["GPL-3.0-only", "MPL-2.0"]
  head "https://github.com/HEnquist/camilladsp.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def fetch
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args, "--bin", "camilladsp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/camilladsp --version")

    (testpath/"input.raw").write("\x00" * 4096)
    (testpath/"config.yml").write <<~YAML
      devices:
        samplerate: 96000
        chunksize: 1024
        resampler:
          type: AsyncSinc
          profile: Fast
        capture_samplerate: 44100
        playback:
          type: File
          channels: 2
          filename: #{testpath}/output.raw
          format: S16_LE
        capture:
          type: RawFile
          channels: 2
          filename: #{testpath}/input.raw
          format: S16_LE
          extra_samples: 0
    YAML

    system bin/"camilladsp", "--check", testpath/"config.yml"
  end
end
