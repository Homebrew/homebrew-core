class Flamegraph < Formula
  desc "Stack trace visualizer"
  homepage "https://github.com/brendangregg/FlameGraph"
  url "https://github.com/brendangregg/FlameGraph/archive/v1.0.tar.gz"
  sha256 "c5ba824228a4f7781336477015cb3b2d8178ffd86bccd5f51864ed52a5ad6675"
  license "CDDL-1.0"
  revision 1
  head "https://github.com/brendangregg/FlameGraph.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "621349d1ff958232ca392b15d7154a7092ed3479a18521df49f6ef291fc40067"
  end

  uses_from_macos "perl"

  def install
    bin.install "flamegraph.pl", "difffolded.pl"
    bin.install "stackcollapse-aix.pl", "stackcollapse-elfutils.pl", "stackcollapse-gdb.pl", "stackcollapse-go.pl",
                "stackcollapse-instruments.pl", "stackcollapse-jstack.pl", "stackcollapse-ljp.awk",
                "stackcollapse-perf-sched.awk", "stackcollapse-perf.pl", "stackcollapse-pmc.pl",
                "stackcollapse-recursive.pl", "stackcollapse-sample.awk", "stackcollapse-stap.pl",
                "stackcollapse-vsprof.pl", "stackcollapse-vtune.pl", "stackcollapse.pl"
    bin.install "files.pl", "pkgsplit-perf.pl", "range-perf.pl"

    if build.head?
      bin.install "stackcollapse-bpftrace.pl", "stackcollapse-java-exceptions.pl", "stackcollapse-xdebug.php"
    end
  end

  test do
    (testpath/"perf-mirageos-stacks-01.txt").write <<~EOS
      mir-console 23166 [000]  1333.768765: cpu-clock:
                44bee3 camlLwt__return_1285 (/mnt/mirage/mirage-skeleton/console.unix2/_build/main.native)
                4093d0 camlMain__fun_1418 (/mnt/mirage/mirage-skeleton/console.unix2/_build/main.native)

      swapper     0 [001]  1333.768770: cpu-clock:
      ffffffff810013aa xen_hypercall_sched_op ([kernel.kallsyms])
      ffffffff8101caaf default_idle ([kernel.kallsyms])
      ffffffff8101d376 arch_cpu_idle ([kernel.kallsyms])
      ffffffff810bef35 cpu_startup_entry ([kernel.kallsyms])
      ffffffff810101b8 cpu_bringup_and_idle ([kernel.kallsyms])

      swapper     0 [002]  1333.768806: cpu-clock:
      ffffffff810013aa xen_hypercall_sched_op ([kernel.kallsyms])
      ffffffff8101caaf default_idle ([kernel.kallsyms])
      ffffffff8101d376 arch_cpu_idle ([kernel.kallsyms])
      ffffffff810bef35 cpu_startup_entry ([kernel.kallsyms])
      ffffffff810101b8 cpu_bringup_and_idle ([kernel.kallsyms])

      swapper     0 [003]  1333.768847: cpu-clock:
      ffffffff810013aa xen_hypercall_sched_op ([kernel.kallsyms])
      ffffffff8101caaf default_idle ([kernel.kallsyms])
      ffffffff8101d376 arch_cpu_idle ([kernel.kallsyms])
      ffffffff810bef35 cpu_startup_entry ([kernel.kallsyms])
      ffffffff810101b8 cpu_bringup_and_idle ([kernel.kallsyms])

      mir-console 23166 [000]  1333.778865: cpu-clock:
                44b1d0 camlLwt__repr_rec_1132 (/mnt/mirage/mirage-skeleton/console.unix2/_build/main.native)
          7f57a760d920 [unknown] ([unknown])
    EOS

    (testpath/"perf-mirageos-stacks-01-collapsed-all.txt").write <<~EOS
      mir-console;camlMain__fun_1418;camlLwt__return_1285 1
      swapper;cpu_bringup_and_idle;cpu_startup_entry;arch_cpu_idle;default_idle;xen_hypercall_sched_op 3
    EOS

    output = shell_output "#{bin}/stackcollapse-perf.pl #{testpath}/perf-mirageos-stacks-01.txt"
    assert_match File.read("#{testpath}/perf-mirageos-stacks-01-collapsed-all.txt"), output

    system "#{bin}/flamegraph.pl", "#{testpath}/perf-mirageos-stacks-01-collapsed-all.txt"
  end
end
