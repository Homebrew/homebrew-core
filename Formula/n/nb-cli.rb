class NbCli < Formula
  desc "Command-line tool for reading, writing, and executing Jupyter notebooks"
  homepage "https://github.com/jupyter-ai-contrib/nb-cli"
  url "https://crates.io/api/v1/crates/nb-cli/0.0.1/download"
  sha256 "c545668e28693d1379eceb552e21a82f0c7233900e65bfe3ce890635984451af"
  license "BSD-3-Clause"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that the binary was installed and can run
    assert_match "nb", shell_output("#{bin}/nb --version")

    # Test basic functionality - create a simple notebook
    (testpath/"test.ipynb").write <<~EOS
      {
        "cells": [],
        "metadata": {},
        "nbformat": 4,
        "nbformat_minor": 5
      }
    EOS

    # Test that nb can read the notebook
    system "#{bin}/nb", "notebook", "read", "test.ipynb"
  end
end
