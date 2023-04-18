class Hyperkit < Formula
  desc "Toolkit for embedding hypervisor capabilities in your application"
  homepage "https://github.com/moby/hyperkit"
  url "https://github.com/moby/hyperkit/archive/v0.20210107.tar.gz"
  sha256 "095f5f5ef550d7cad10e4d13e9c9ce8b58cc319d654a6d837d8d87ee70537835"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:  "3b67078315551718bc3c752b943b933713ddb69058f3cb72a0f65faa6e9295ab"
    sha256 cellar: :any_skip_relocation, monterey: "da3b0d0374a85af5c649c86fb7796c1eecae468f5783bbb994a96d807e60712a"
    sha256 cellar: :any_skip_relocation, big_sur:  "f96e7270e9e853ce33f2195136b11338a5cf4d612ee50f3dd51b5c8506b4efcb"
    sha256 cellar: :any_skip_relocation, catalina: "cd58afe172473278d3ed9404e9d25e10bee487fb4e27cd6de39c950a0ccaca87"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: ["9.0", :build]
  depends_on arch: :x86_64
  depends_on "libev"
  depends_on :macos # Uses Hypervisor.framework, a component of macOS.

  resource "tinycorelinux" do
    url "https://github.com/Homebrew/homebrew-core/files/6405545/tinycorelinux_8.x.tar.gz"
    sha256 "560c1d2d3a0f12f9b1200eec57ca5c1d107cf4823d3880e09505fcd9cd39141a"
  end

  def install
    system "opam", "init", "--disable-sandboxing", "--no-setup"
    opam_dir = "#{buildpath}/.brew_home/.opam"
    ENV["CAML_LD_LIBRARY_PATH"] = "#{opam_dir}/system/lib/stublibs:#{Formula["ocaml"].opt_lib}/ocaml/stublibs"
    ENV["OPAMUTF8MSGS"] = "1"
    ENV["PERL5LIB"] = "#{opam_dir}/system/lib/perl5"
    ENV["OCAML_TOPLEVEL_PATH"] = "#{opam_dir}/system/lib/toplevel"
    ENV.prepend_path "PATH", "#{opam_dir}/system/bin"

    system "opam", "exec", "--",
           "opam", "install", "-y", "uri.4.2.0", "qcow.0.11.0", "conduit.2.1.0", "lwt.5.3.0",
           "qcow-tool.0.11.0", "mirage-block-unix.2.12.0", "conf-libev.4-11", "logs.0.7.0", "fmt.0.8.8",
           "mirage-unix.4.0.0", "prometheus-app.0.7"

    args = []
    args << "GIT_VERSION=#{version}"
    system "opam", "exec", "--", "make", *args

    bin.install "build/hyperkit"
    man1.install "hyperkit.1"
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/hyperkit -v 2>&1"))

    if Hardware::CPU.features.include? :vmx
      resource("tinycorelinux").stage do |context|
        tmpdir = context.staging.tmpdir
        path_resource_versioned = Dir.glob(tmpdir.join("tinycorelinux_[0-9]*"))[0]
        cp(File.join(path_resource_versioned, "vmlinuz"), testpath)
        cp(File.join(path_resource_versioned, "initrd.gz"), testpath)
      end

      (testpath / "test_hyperkit.exp").write <<-EOS
        #!/usr/bin/env expect -d
        set KERNEL "./vmlinuz"
        set KERNEL_INITRD "./initrd.gz"
        set KERNEL_CMDLINE "earlyprintk=serial console=ttyS0"
        set MEM {512M}
        set PCI_DEV1 {0:0,hostbridge}
        set PCI_DEV2 {31,lpc}
        set LPC_DEV {com1,stdio}
        set ACPI {-A}
        spawn #{bin}/hyperkit $ACPI -m $MEM -s $PCI_DEV1 -s $PCI_DEV2 -l $LPC_DEV -f kexec,$KERNEL,$KERNEL_INITRD,$KERNEL_CMDLINE
        set pid [exp_pid]
        set timeout 20
        expect {
          timeout { puts "FAIL boot"; exec kill -9 $pid; exit 1 }
          "\\r\\ntc@box:~$ "
        }
        send "sudo halt\\r\\n";
        expect {
          timeout { puts "FAIL shutdown"; exec kill -9 $pid; exit 1 }
          "reboot: System halted"
        }
        expect eof
        puts "\\nPASS"
      EOS
      system "expect", "test_hyperkit.exp"
    end
  end
end
