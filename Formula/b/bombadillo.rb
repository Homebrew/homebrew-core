class Bombadillo < Formula
  desc "Non-web browser, designed for a growing list of protocols"
  homepage "https://bombadillo.colorfield.space/"
  # Using git checkout to avoid Gitea upgrades impacting git archive tarballs.
  url "https://tildegit.org/sloum/bombadillo.git",
      tag:      "2.4.0",
      revision: "30e550c183b197300299640bcb51f73d94244a4e"
  license "GPL-3.0-or-later"
  head "https://tildegit.org/sloum/bombadillo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25d81107bb925217646f97e2151e3fe2abfa597541a847c5eeeaef4dab55f022"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31498bb84196e03bdbb936dc1528b02b3355832cc0a8ebd01dbdf176376caabc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "704af144b953977108282ec76083d51d8d359b2f08402aa71da7822a79491591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "48693234c0c87251efbb8f2d4cf5c23a4d4585c9b6ba00907122dbc59a6a5add"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "5b792d8b1afcc6cb894aec708268f8099e8b70a3f8a629db32d0290a535a6800"
    sha256 cellar: :any_skip_relocation, arm64_monterey:    "d78dae1cc03b2b801036ba0dfd19dbb9d47e491acac9ad1ea141a40eb6b4961b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:     "02c4423c500ab7e3fb19df4e68708cb9ded9197986aae6e1783cb3a79d592fd7"
    sha256 cellar: :any_skip_relocation, sonoma:            "a11e33aea16006a92c4106d122b756465d1fdda704c35a136e25824ca9926e99"
    sha256 cellar: :any_skip_relocation, ventura:           "e50be305e669ce2f6d47976b6515480d9ac9b88227e614d46f1da296bbbc2d63"
    sha256 cellar: :any_skip_relocation, monterey:          "ae21a5cc0383684f7080eb62468d91db698f901c3ce4332e933b5a72edce3041"
    sha256 cellar: :any_skip_relocation, big_sur:           "cb6a7684e76b5d8eebc23776181cbf6a3e798b3c6a1156772c2fff010fd6fc12"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22151314103e03dba1c70db82812e1e7565fcf636b615d039f155a59217e050c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8512c76f2d7a4ed9535fad9ed424f0e0da8a39240bbd90448c3e37600b13d650"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"
    require "io/console"

    output_log = testpath/"output.log"
    r, w, pid = PTY.spawn(bin/"bombadillo", "gopher://bombadillo.colorfield.space", [:out, :err] => output_log.to_s)
    r.winsize = [43, 80]
    sleep 1
    w.write "q"
    begin
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    status = PTY.check(pid)
    refute_nil status
    assert status.success?
    assert_match "Bombadillo is a non-web browser", output_log.read
  end
end
