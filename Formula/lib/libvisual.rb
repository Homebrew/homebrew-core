class Libvisual < Formula
  desc "Audio Visualization tool and library"
  homepage "https://github.com/Libvisual/libvisual"
  url "https://github.com/Libvisual/libvisual/releases/download/libvisual-0.4.2/libvisual-0.4.2.tar.gz"
  sha256 "63085fd9835c42c9399ea6bb13a7ebd4b1547ace75c4595ce8e9759512bd998a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "0c7cc4aed9aca8fac6ca7f969966365592eaacbb29db5340f08dce1c0a9fa65a"
    sha256 cellar: :any, arm64_sequoia:  "a3cf1f8ac6ed58fce5959717d16802adeb1920abfe6c421145de66eff2e9a51a"
    sha256 cellar: :any, arm64_sonoma:   "c56b6225bce042d7c7984074c9c508e2ab4d4c17491f941d72dbfc0cee0c3caa"
    sha256 cellar: :any, arm64_ventura:  "ba00f3f40ff28fe23cfea28a9a4782dd8e344e51d318cd9843c74fc3d52fe65a"
    sha256 cellar: :any, arm64_monterey: "f9faaf86d813119e9c592781ec40405057118cc8567838bc77e30e757c6088da"
    sha256 cellar: :any, arm64_big_sur:  "b789ada9eec40f397f5fc4e203abdbdce87da28c353e6b31f503a2b87f684c93"
    sha256 cellar: :any, sonoma:         "73b2ed9dd9a84d784a31b662f202e236f0d6158346ce931b77d1205ca390faad"
    sha256 cellar: :any, ventura:        "de0973df1bed9f47df99760b65c9e32fc44302b0931e5b41e47768cb3f6ea01e"
    sha256 cellar: :any, monterey:       "8cf0b4866dee89d477602b4de996f10ad8115158c7a1fc0a04bfdf6b55ab7084"
    sha256 cellar: :any, big_sur:        "6912bc1436fd9aa261090f4c0877c3b17b1aa8301defdb17c66f5f3410d060e1"
    sha256               arm64_linux:    "c1037bb9d22337170f186be7d8ad1ccce9ef18dcf55e92cbd8424b7495204d03"
    sha256               x86_64_linux:   "ceefedcaeb4e18c06c22c2a210e35d3439783f2f457107090d91d2b777e788f2"
  end

  depends_on "pkgconf" => :build
  depends_on "sdl12-compat"

  def install
    # NOTE: Other formulae would not be able to install to libvisual's cellar
    #       so we rely on brew's auto-symlinking to
    #       <HOMEBREW_PREFIX>/lib/libvisual-<major>.<minor> .
    #       See libvisual-plugins.rb and/or libvisual-projectm.rb
    #       for how this is used by a formula installing libvisual plug-ins.
    inreplace "configure",
      "LIBVISUAL_PLUGINS_BASE_DIR=\"${libdir}/libvisual-${LIBVISUAL_VERSION_SUFFIX}\"",
      "LIBVISUAL_PLUGINS_BASE_DIR=\"#{HOMEBREW_PREFIX}/lib/libvisual-#{version.major_minor}\""

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # NOTE: Without any plug-ins, there is no more that we could test.
    lv_tool = bin/"lv-tool-#{version.major_minor}"
    assert_match version.to_s, shell_output("#{lv_tool} --version")
  end
end
